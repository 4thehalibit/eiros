# Configures systemd-boot and EFI boot loader settings.
{ config, lib, ... }:
let
  eiros_boot = config.eiros.system.boot;
in
{
  options.eiros.system.boot.loader = {
    efi = {
      can_touch_efi_vars = lib.mkOption {
        default = true;
        description = "Allow the kernel to touch EFI variables.";
        example = false;
        type = lib.types.bool;
      };

      enable = lib.mkOption {
        default = true;
        description = "Enable EFI boot support.";
        example = false;
        type = lib.types.bool;
      };

      sys_mount_point = lib.mkOption {
        default = "/boot";
        description = "Mount point of the EFI system partition (e.g. \"/boot\" or \"/boot/efi\").";
        example = "/boot/efi";
        type = lib.types.str;
      };
    };

    systemd_boot = {
      configuration_limit = lib.mkOption {
        default = 3;
        description = "Number of systemd-boot entries (generations) to keep on the ESP.";
        example = 5;
        type = lib.types.int;
      };

      enable = lib.mkOption {
        default = true;
        description = "Enable systemd-boot.";
        example = false;
        type = lib.types.bool;
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = eiros_boot.loader.systemd_boot.configuration_limit > 0;
        message = "eiros.system.boot.loader.systemd_boot.configuration_limit must be > 0.";
      }
      {
        assertion = !eiros_boot.loader.systemd_boot.enable || eiros_boot.loader.efi.enable;
        message = "systemd-boot requires EFI; set eiros.system.boot.loader.efi.enable = true.";
      }
    ];

    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = eiros_boot.loader.efi.can_touch_efi_vars;
          efiSysMountPoint = eiros_boot.loader.efi.sys_mount_point;
        };

        systemd-boot = {
          configurationLimit = lib.mkDefault eiros_boot.loader.systemd_boot.configuration_limit;
          enable = eiros_boot.loader.systemd_boot.enable;
        };
      };
    };
  };
}
