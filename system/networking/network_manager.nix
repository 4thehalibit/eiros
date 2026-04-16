# Configures NetworkManager with optional iwd Wi-Fi backend.
{ config, lib, ... }:
let
  eiros_networking = config.eiros.system.networking;
in
{
  options.eiros.system.networking = {
    iwd.enable = lib.mkOption {
      default = true;
      description = "Use iwd as the Wi-Fi backend (via NetworkManager).";
      example = false;
      type = lib.types.bool;
    };

    network_manager = {
      enable = lib.mkOption {
        default = true;
        description = "Use NetworkManager for network configuration.";
        example = false;
        type = lib.types.bool;
      };
    };
  };

  config = {
    assertions = [
      {
        assertion =
          !eiros_networking.network_manager.enable || !(config.networking.wireless.enable or false);
        message = "NetworkManager is enabled; disable networking.wireless.enable to avoid conflicting Wi-Fi management.";
      }
    ];

    networking = {
      networkmanager = lib.mkIf eiros_networking.network_manager.enable {
        enable = true;

        wifi = lib.mkIf eiros_networking.iwd.enable {
          backend = "iwd";
        };
      };
    };
  };
}
