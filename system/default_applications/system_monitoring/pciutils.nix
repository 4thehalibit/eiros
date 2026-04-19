# Installs pciutils (lspci) for PCI device inspection.
{ config, lib, pkgs, ... }:
let
  eiros_pciutils = config.eiros.system.default_applications.system_monitoring.pciutils;
in
{
  options.eiros.system.default_applications.system_monitoring.pciutils.enable = lib.mkOption {
    default = true;
    description = "Install pciutils (lspci) for PCI device inspection.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.system_monitoring.pciutils.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_pciutils.enable {
    environment.systemPackages = [ pkgs.pciutils ];
  };
}
