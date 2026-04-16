# Configures XDG Desktop Portal backends for Wayland file chooser and settings integration.
{ config, lib, pkgs, ... }:
let
  eiros_xdg_portal = config.eiros.system.desktop_environment.xdg_portal;
in
{
  options.eiros.system.desktop_environment.xdg_portal = {
    enable = lib.mkOption {
      default = true;
      description = "Enable XDG Desktop Portal (wlroots + GTK) for Wayland desktop integration.";
      example = false;
      type = lib.types.bool;
    };

    extra_portals = lib.mkOption {
      default = [ pkgs.xdg-desktop-portal-gtk ];
      description = "Additional XDG portal backend packages to install alongside xdg-desktop-portal-wlr.";
      example = lib.literalExpression "[ pkgs.xdg-desktop-portal-kde ]";
      type = lib.types.listOf lib.types.package;
    };
  };

  config = lib.mkIf eiros_xdg_portal.enable {
    xdg.portal = {
      enable = true;

      wlr.enable = true;

      extraPortals = eiros_xdg_portal.extra_portals;

      config.common = {
        default = [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        # Route credential storage through GTK so browsers can use GNOME Keyring.
        "org.freedesktop.impl.portal.Secret" = [ "gtk" ];
      };
    };
  };
}
