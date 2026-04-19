# Installs eza, a modern ls replacement with colour, icons, and git status.
{ config, lib, pkgs, ... }:
let
  eiros_eza = config.eiros.system.default_applications.file_management.eza;
in
{
  options.eiros.system.default_applications.file_management.eza.enable = lib.mkOption {
    default = true;
    description = "Install eza, a modern ls replacement with colour, icons, and git status.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.file_management.eza.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_eza.enable {
    environment.systemPackages = [ pkgs.eza ];
  };
}
