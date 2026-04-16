# Sets the system hostname and optional domain name.
{ config, lib, ... }:
let
  eiros_networking = config.eiros.system.networking;
in
{
  options.eiros.system.networking = {
    hostname = lib.mkOption {
      default = "eiros";
      description = "Hostname to use for the Eiros system.";
      example = "my-machine";
      type = lib.types.str;
    };

    domain = lib.mkOption {
      default = null;
      description = "Optional domain name (sets networking.domain).";
      example = "local";
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = {
    assertions = [
      {
        assertion = eiros_networking.hostname != "";
        message = "eiros.system.networking.hostname must not be empty.";
      }
    ];

    networking = {
      hostName = eiros_networking.hostname;
      domain = eiros_networking.domain;
    };
  };
}
