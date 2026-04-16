# Installs ncdu, an interactive TUI disk usage analyzer.
{ config, lib, pkgs, ... }:
let
  eiros_ncdu = config.eiros.system.default_applications.ncdu;
in
{
  options.eiros.system.default_applications.ncdu.enable = lib.mkOption {
    default = true;
    description = "Install ncdu interactive disk usage analyzer.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.ncdu.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_ncdu.enable {
    environment.systemPackages = [ pkgs.ncdu ];
  };
}
