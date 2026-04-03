{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_xdg_portal = config.eiros.system.desktop_environment.xdg_portal;
in
{
  options.eiros.system.desktop_environment.xdg_portal = {
    enable = lib.mkOption {
      default = true;
      description = "Enable XDG Desktop Portal (wlroots + GTK) for Wayland desktop integration.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_xdg_portal.enable {
    environment.systemPackages = [
      pkgs.grim
      pkgs.slurp
    ];

    xdg.portal = {
      enable = true;

      wlr.enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];

      config.common = {
        default = [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        # Route Secret portal to gtk so browsers and Electron apps can
        # store credentials in GNOME Keyring without re-prompting each launch.
        "org.freedesktop.impl.portal.Secret" = [ "gtk" ];
      };
    };
  };
}
