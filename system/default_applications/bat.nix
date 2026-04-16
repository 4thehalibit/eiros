# Installs bat, a syntax-highlighting cat replacement with git integration.
{ config, lib, pkgs, ... }:
let
  eiros_bat = config.eiros.system.default_applications.bat;
in
{
  options.eiros.system.default_applications.bat.enable = lib.mkOption {
    default = true;
    description = "Install bat, a cat replacement with syntax highlighting and git integration.";
    example = false;
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_bat.enable {
    environment.systemPackages = [ pkgs.bat ];
  };
}
