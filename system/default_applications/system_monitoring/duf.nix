# Installs duf, a modern disk usage viewer (df replacement) with colored output.
{ config, lib, pkgs, ... }:
let
  eiros_duf = config.eiros.system.default_applications.system_monitoring.duf;
in
{
  options.eiros.system.default_applications.system_monitoring.duf.enable = lib.mkOption {
    default = true;
    description = "Install duf, a modern df replacement with colored output and sorting.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.system_monitoring.duf.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_duf.enable {
    environment.systemPackages = [ pkgs.duf ];
  };
}
