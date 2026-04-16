{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_firmware = config.eiros.system.hardware.firmware;
in
{
  options.eiros.system.hardware.firmware = {
    all_firmware = {
      enable = lib.mkOption {
        default = true;
        description = "Enable all supported firmware.";
        type = lib.types.bool;
      };
    };

    extra_packages = lib.mkOption {
      default = [ ];
      description = "Additional firmware packages to install (added to hardware.firmware).";
      type = lib.types.listOf lib.types.package;
    };

    fwupd = {
      enable = lib.mkOption {
        default = true;
        description = "Enable fwupd (firmware update daemon, used by KDE Discover).";
        type = lib.types.bool;
      };
    };
  };

  config = {
    warnings =
      lib.optionals (eiros_firmware.all_firmware.enable && !(config.nixpkgs.config.allowUnfree or false))
        [
          "eiros.system.hardware.firmware.all_firmware.enable is enabled, but nixpkgs.config.allowUnfree is false; some firmware may be unavailable."
        ];

    hardware = {
      enableAllFirmware = eiros_firmware.all_firmware.enable;
      firmware = eiros_firmware.extra_packages;
    };

    services.fwupd.enable = eiros_firmware.fwupd.enable;
  };
}
