# Configures the system time zone and enables systemd-timesyncd for NTP sync.
{ config, lib, ... }:
let
  eiros_time = config.eiros.system.time;
in
{
  options.eiros.system.time = {
    time_zone = lib.mkOption {
      default = "America/Chicago";
      description = "The system time zone. Must be a valid IANA timezone (e.g. \"America/Chicago\", \"Europe/London\").";
      example = "Europe/London";
      type = lib.types.str;
    };

    timesync.enable = lib.mkOption {
      default = true;
      description = "Enable time synchronization (systemd-timesyncd).";
      example = false;
      type = lib.types.bool;
    };
  };

  config = {
    assertions = [
      {
        assertion = builtins.match ".+/.+" eiros_time.time_zone != null;
        message = "eiros.system.time.time_zone must be a valid IANA timezone in Region/City format (e.g. \"America/Chicago\").";
      }
    ];

    time.timeZone = eiros_time.time_zone;

    services.timesyncd.enable = eiros_time.timesync.enable;
  };
}
