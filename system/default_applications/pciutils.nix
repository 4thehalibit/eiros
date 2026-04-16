# Installs pciutils (lspci) for PCI device inspection.
{ config, lib, pkgs, ... }:
let
  eiros_pciutils = config.eiros.system.default_applications.pciutils;
in
{
  options.eiros.system.default_applications.pciutils.enable = lib.mkOption {
    default = true;
    description = "Install pciutils (lspci) for PCI device inspection.";
    example = false;
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_pciutils.enable {
    environment.systemPackages = [ pkgs.pciutils ];
  };
}
