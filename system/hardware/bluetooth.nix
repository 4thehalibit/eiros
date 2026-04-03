{ config, lib, ... }:
let
  eiros_bluetooth = config.eiros.system.hardware.bluetooth;
in
{
  options.eiros.system.hardware.bluetooth = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Bluetooth support.";
      type = lib.types.bool;
    };

    pipewire = {
      enable = lib.mkOption {
        default = true;
        description = "Enable Bluetooth audio support optimized for PipeWire.";
        type = lib.types.bool;
      };

      roles = lib.mkOption {
        default = [
          "Source"
          "Sink"
          "Media"
        ];
        description = "Bluetooth audio roles to enable (PipeWire/BlueZ). Valid BlueZ General.Enable values: Controller, Bredr, Hs, Audio, Source, Sink, Health, Media.";
        type = lib.types.listOf (lib.types.enum [
          "Controller"
          "Bredr"
          "Hs"
          "Audio"
          "Source"
          "Sink"
          "Health"
          "Media"
        ]);
      };
    };
  };

  config = lib.mkIf eiros_bluetooth.enable {
    hardware = {
      bluetooth = {
        enable = true;

        settings = lib.mkIf eiros_bluetooth.pipewire.enable {
          General = {
            Enable = lib.concatStringsSep "," eiros_bluetooth.pipewire.roles;
          };
        };
      };
    };
  };
}
