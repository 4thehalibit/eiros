# Installs bat, a syntax-highlighting cat replacement with git integration.
{ config, lib, pkgs, ... }:
let
  eiros_bat = config.eiros.system.default_applications.file_management.bat;
in
{
  options.eiros.system.default_applications.file_management.bat.enable = lib.mkOption {
    default = true;
    description = "Install bat, a cat replacement with syntax highlighting and git integration.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.file_management.bat.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_bat.enable {
    environment.systemPackages = [ pkgs.bat ];
  };
}
