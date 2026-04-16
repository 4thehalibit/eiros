# Configures CUPS printing and SANE scanning with optional Avahi network discovery.
{ config, lib, pkgs, ... }:
let
  eiros_printing = config.eiros.system.hardware.printing;
  eiros_scanning = config.eiros.system.hardware.scanning;
in
{
  options.eiros.system.hardware.printing = {
    enable = lib.mkOption {
      default = false;
      description = "Enable CUPS printing support.";
      example = true;
      type = lib.types.bool;
    };

    drivers = lib.mkOption {
      default = [ ];
      description = "CUPS driver packages to install (e.g. pkgs.hplip, pkgs.gutenprint).";
      example = lib.literalExpression "[ pkgs.gutenprint ]";
      type = lib.types.listOf lib.types.package;
    };

    discovery = {
      enable = lib.mkOption {
        default = true;
        description = "Enable Avahi mDNS-based network printer discovery.";
        example = false;
        type = lib.types.bool;
      };

      nssmdns4 = lib.mkOption {
        default = true;
        description = "Enable Avahi's nssmdns4 NSS module for resolving .local hostnames via mDNS over IPv4.";
        example = false;
        type = lib.types.bool;
      };
    };
  };

  options.eiros.system.hardware.scanning = {
    enable = lib.mkOption {
      default = false;
      description = "Enable scanner support via SANE.";
      example = true;
      type = lib.types.bool;
    };

    airscan.enable = lib.mkOption {
      default = true;
      description = "Enable sane-airscan for network scanner discovery (eSCL/WSD protocol).";
      example = false;
      type = lib.types.bool;
    };

    extra_backends = lib.mkOption {
      default = [ ];
      description = "Additional SANE backend packages (e.g. pkgs.hplipWithPlugin for HP scanners).";
      example = lib.literalExpression "[ pkgs.sane-airscan ]";
      type = lib.types.listOf lib.types.package;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf eiros_printing.enable {
      services.printing = {
        enable = true;
        drivers = eiros_printing.drivers;
      };

      services.avahi = lib.mkIf eiros_printing.discovery.enable {
        enable = true;
        nssmdns4 = eiros_printing.discovery.nssmdns4;
      };
    })

    (lib.mkIf eiros_scanning.enable {
      hardware.sane = {
        enable = true;
        extraBackends =
          lib.optionals eiros_scanning.airscan.enable [ pkgs.sane-airscan ]
          ++ eiros_scanning.extra_backends;
      };
    })
  ];
}
