{ config, lib, pkgs, ... }:
let
  eiros_printing = config.eiros.system.hardware.printing;
in
{
  options.eiros.system.hardware.printing = {
    enable = lib.mkOption {
      default = false;
      description = "Enable CUPS printing support.";
      type = lib.types.bool;
    };

    drivers = lib.mkOption {
      default = [ ];
      description = "CUPS driver packages to install (e.g. pkgs.hplip, pkgs.gutenprint).";
      type = lib.types.listOf lib.types.package;
    };

    discovery.enable = lib.mkOption {
      default = true;
      description = "Enable Avahi mDNS-based network printer discovery.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_printing.enable {
    services.printing = {
      enable = true;
      drivers = eiros_printing.drivers;
    };

    services.avahi = lib.mkIf eiros_printing.discovery.enable {
      enable = true;
      nssmdns4 = true;
    };
  };
}
