# Enables the MangoWC Wayland compositor and configures its systemd environment import.
{ config, lib, ... }:
let
  eiros_mangowc = config.eiros.system.desktop_environment.mangowc;
in
{
  options.eiros.system.desktop_environment.mangowc = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the Mango Window Composer.";
      example = false;
      type = lib.types.bool;
    };

    systemd = {
      enable = lib.mkOption {
        default = true;
        description = "Propagate Wayland session environment variables into systemd and D-Bus on MangoWC startup.";
        example = false;
        type = lib.types.bool;
      };

      variables = lib.mkOption {
        default = [
          "DISPLAY"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
          "NIXOS_OZONE_WL"
          "XCURSOR_THEME"
          "XCURSOR_SIZE"
          "GNOME_KEYRING_CONTROL"
        ];
        description = "Environment variables to import into the systemd user session on MangoWC startup.";
        example = [
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
        ];
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config = lib.mkIf eiros_mangowc.enable {
    programs.mango.enable = true;
  };
}
