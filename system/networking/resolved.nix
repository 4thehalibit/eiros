{ config, lib, ... }:
let
  eiros_resolved = config.eiros.system.networking.resolved;
in
{
  options.eiros.system.networking.resolved = {
    enable = lib.mkOption {
      default = true;
      description = "Enable systemd-resolved as the stub DNS resolver. Improves split-DNS, DNSSEC, and LLMNR support, particularly on a roaming laptop.";
      type = lib.types.bool;
    };

    dnssec = lib.mkOption {
      default = "allow-downgrade";
      description = "DNSSEC validation mode (true, allow-downgrade, false).";
      type = lib.types.enum [ "true" "allow-downgrade" "false" ];
    };
  };

  config = lib.mkIf eiros_resolved.enable {
    services.resolved = {
      enable = true;
      settings.Resolve.DNSSEC = eiros_resolved.dnssec;
    };
  };
}
