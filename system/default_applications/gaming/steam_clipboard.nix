# Syncs X11 PRIMARY and CLIPBOARD selections for live copy/paste between XWayland apps (Steam/Proton games) and Wayland.
{ config, lib, pkgs, ... }:
let
  eiros_steam_clipboard = config.eiros.system.default_applications.gaming.steam_clipboard;

  # Polls the Wayland clipboard every 100ms and writes any new content into X11
  # CLIPBOARD so XWayland apps (games/Proton) can paste it. Using wl-paste --watch
  # directly causes xclip to daemonize and block subsequent watch events, so we
  # poll instead.
  wayland-to-x11-clipboard = pkgs.writeShellScript "wayland-to-x11-clipboard" ''
    prev=""
    while true; do
      current=$(${pkgs.wl-clipboard}/bin/wl-paste -n 2>/dev/null) || true
      if [ -n "$current" ] && [ "$current" != "$prev" ]; then
        printf '%s' "$current" | ${pkgs.xclip}/bin/xclip -selection clipboard &
        prev="$current"
      fi
      sleep 0.1
    done
  '';
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
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection CLIPBOARD";
          Restart = "on-failure";
          RestartSec = 1;
        };
      };

      systemd.user.services.autocutsel-primary = {
        description = "Sync X11 CLIPBOARD into PRIMARY selection";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY";
          Restart = "on-failure";
          RestartSec = 1;
        };
      };

      # The compositor does not push Wayland clipboard changes into XWayland's X11
      # clipboard. This service polls every 100ms and writes new content into X11
      # CLIPBOARD so running games can paste from it.
      systemd.user.services.wayland-to-x11-clipboard = {
        description = "Poll Wayland clipboard and push changes into X11 CLIPBOARD for XWayland apps";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${wayland-to-x11-clipboard}";
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
