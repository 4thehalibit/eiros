# Enables XWayland compatibility layer for running X11 applications under Wayland.
{ config, lib, ... }:
let
  eiros_xwayland = config.eiros.system.desktop_environment.xwayland;
in
{
  options.eiros.system.desktop_environment.xwayland.enable = lib.mkOption {
    default = true;
    description = "Enable XWayland for running X11 applications under Wayland.";
    example = false;
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_xwayland.enable {
    programs.xwayland.enable = true;
  };
}
