{ config, lib, pkgs, ... }:
let
  eiros_scanning = config.eiros.system.hardware.scanning;
in
{
  options.eiros.system.hardware.scanning = {
    enable = lib.mkOption {
      default = false;
      description = "Enable scanner support via SANE.";
      type = lib.types.bool;
    };

    airscan.enable = lib.mkOption {
      default = true;
      description = "Enable sane-airscan for network scanner discovery (eSCL/WSD protocol).";
      type = lib.types.bool;
    };

    extra_backends = lib.mkOption {
      default = [ ];
      description = "Additional SANE backend packages (e.g. pkgs.hplipWithPlugin for HP scanners).";
      type = lib.types.listOf lib.types.package;
    };
  };

  config = lib.mkIf eiros_scanning.enable {
    hardware.sane = {
      enable = true;
      extraBackends =
        lib.optionals eiros_scanning.airscan.enable [ pkgs.sane-airscan ]
        ++ eiros_scanning.extra_backends;
    };
  };
}
