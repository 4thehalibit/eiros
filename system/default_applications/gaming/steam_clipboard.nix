# Syncs X11 PRIMARY and CLIPBOARD selections for live copy/paste between XWayland apps (Steam/Proton games) and Wayland.
{ config, lib, pkgs, ... }:
let
  eiros_steam_clipboard = config.eiros.system.default_applications.gaming.steam_clipboard;

  # programs.mango (MangoWC) has no systemd integration at the NixOS level —
  # that lives in the Home Manager module which is not used here. As a result,
  # graphical-session.target is never activated and services depending on it
  # never start. All daemons below use default.target instead and wait for
  # their required display sockets to appear before doing any work.

  # Wraps autocutsel to wait for an XWayland socket before starting.
  # 'selection' should be "CLIPBOARD" or "PRIMARY" (uppercase, passed directly
  # to autocutsel's -selection flag).
  autocutsel-wait = selection: pkgs.writeShellApplication {
    name = "autocutsel-${lib.toLower selection}";
    runtimeInputs = with pkgs; [ autocutsel findutils coreutils ];
    text = ''
      # Wait for any XWayland socket to appear
      until find /tmp/.X11-unix -maxdepth 1 -name 'X*' 2>/dev/null | grep -q .; do
        sleep 1
      done
      # Use the first available X11 display
      sock=$(find /tmp/.X11-unix -maxdepth 1 -name 'X*' 2>/dev/null | sort | head -1)
      export DISPLAY=":''${sock##*/X}"
      exec autocutsel -selection ${selection}
    '';
  };

  # Polls the Wayland clipboard every 100ms and writes any new content into X11
  # CLIPBOARD so XWayland apps (games/Proton) can paste it. Waits for both the
  # Wayland compositor socket and an XWayland socket before starting the loop.
  wayland-to-x11-clipboard = pkgs.writeShellApplication {
    name = "wayland-to-x11-clipboard";
    runtimeInputs = with pkgs; [ wl-clipboard xclip findutils coreutils ];
    text = ''
      runtime_dir="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

      # Wait for Wayland compositor socket
      until find "$runtime_dir" -maxdepth 1 -name 'wayland-*' -type s 2>/dev/null | grep -q .; do
        sleep 1
      done
      sock=$(find "$runtime_dir" -maxdepth 1 -name 'wayland-*' -type s 2>/dev/null | sort | head -1)
      export WAYLAND_DISPLAY="''${sock##*/}"

      # Wait for XWayland socket
      until find /tmp/.X11-unix -maxdepth 1 -name 'X*' 2>/dev/null | grep -q .; do
        sleep 1
      done
      x11_sock=$(find /tmp/.X11-unix -maxdepth 1 -name 'X*' 2>/dev/null | sort | head -1)
      export DISPLAY=":''${x11_sock##*/X}"

      prev=""
      while true; do
        current=$(wl-paste -n 2>/dev/null) || true
        if [ -n "$current" ] && [ "$current" != "$prev" ]; then
          printf '%s' "$current" | xclip -selection clipboard &
          prev="$current"
        fi
        sleep 0.1
      done
    '';
  };
in
{
  options.eiros.system.default_applications.gaming.steam_clipboard.enable = lib.mkOption {
    default = true;
    description = "Bridge clipboard between Wayland and X11 (XWayland) for live copy/paste to and from Proton games. Runs autocutsel to sync X11 PRIMARY↔CLIPBOARD and a polling daemon to push Wayland clipboard changes into X11. When Steam is enabled, also injects wl-clipboard-x11 and xdotool into its FHS container.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.gaming.steam_clipboard.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkMerge [
    (lib.mkIf eiros_steam_clipboard.enable {
      systemd.user.services.autocutsel-clipboard = {
        description = "Sync X11 PRIMARY selection into CLIPBOARD";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${autocutsel-wait "CLIPBOARD"}/bin/autocutsel-clipboard";
          Restart = "on-failure";
          RestartSec = 1;
        };
      };

      systemd.user.services.autocutsel-primary = {
        description = "Sync X11 CLIPBOARD into PRIMARY selection";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${autocutsel-wait "PRIMARY"}/bin/autocutsel-primary";
          Restart = "on-failure";
          RestartSec = 1;
        };
      };

      systemd.user.services.wayland-to-x11-clipboard = {
        description = "Poll Wayland clipboard and push changes into X11 CLIPBOARD for XWayland apps";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${wayland-to-x11-clipboard}/bin/wayland-to-x11-clipboard";
          Restart = "on-failure";
          RestartSec = 1;
        };
      };
    })

    (lib.mkIf (eiros_steam_clipboard.enable && config.programs.steam.enable) {
      programs.steam.extraPackages = with pkgs; [
        wl-clipboard-x11
        xdotool
      ];
    })
  ];
}
