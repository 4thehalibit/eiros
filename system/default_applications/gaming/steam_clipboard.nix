# Syncs X11 PRIMARY and CLIPBOARD selections for live copy/paste between XWayland apps (Steam/Proton games) and Wayland.
{ config, lib, pkgs, ... }:
let
  eiros_steam_clipboard = config.eiros.system.default_applications.gaming.steam_clipboard;
in
{
  options.eiros.system.default_applications.gaming.steam_clipboard.enable = lib.mkOption {
    default = true;
    description = "Run autocutsel daemons to sync X11 PRIMARY and CLIPBOARD selections, enabling live copy/paste between Proton games (XWayland) and Wayland-native apps. When Steam is enabled, also injects wl-clipboard-x11 and xdotool into its FHS container.";
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
    })

    (lib.mkIf (eiros_steam_clipboard.enable && config.programs.steam.enable) {
      programs.steam.extraPackages = with pkgs; [
        wl-clipboard-x11
        xdotool
      ];
    })
  ];
}
