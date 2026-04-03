{ config, lib, ... }:
let
  eiros_journald = config.eiros.system.logging.journald;
in
{
  options.eiros.system.logging.journald = {
    enable = lib.mkOption {
      default = true;
      description = "Enable sane systemd-journald limits and retention.";
      type = lib.types.bool;
    };

    persistent.enable = lib.mkOption {
      default = true;
      description = "Store logs persistently on disk (Storage=persistent).";
      type = lib.types.bool;
    };

    retention = {
      max_use = lib.mkOption {
        default = "1G";
        description = "Maximum disk space to use for journals (SystemMaxUse).";
        type = lib.types.str;
      };

      max_file_size = lib.mkOption {
        default = "128M";
        description = "Maximum size of individual journal files (SystemMaxFileSize).";
        type = lib.types.str;
      };

      max_retention_sec = lib.mkOption {
        default = "1month";
        description = "Maximum retention time for journal entries (MaxRetentionSec).";
        type = lib.types.str;
      };
    };

    rate_limit = {
      interval_sec = lib.mkOption {
        default = "30s";
        description = "Rate limit interval (RateLimitIntervalSec).";
        type = lib.types.str;
      };

      burst = lib.mkOption {
        default = 1000;
        description = "Rate limit burst (RateLimitBurst).";
        type = lib.types.int;
      };
    };

    vacuum = {
      enable = lib.mkOption {
        default = true;
        description = "Enable periodic journal vacuuming (systemd-tmpfiles).";
        type = lib.types.bool;
      };

      dates = lib.mkOption {
        default = "weekly";
        description = "systemd OnCalendar schedule for vacuuming.";
        type = lib.types.str;
      };

      keep_free = lib.mkOption {
        default = "500M";
        description = "Minimum disk space to keep free when vacuuming (journalctl --vacuum-size).";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf eiros_journald.enable {
    services.journald.settings.Journal = {
      Storage = if eiros_journald.persistent.enable then "persistent" else "volatile";
      SystemMaxUse = eiros_journald.retention.max_use;
      SystemMaxFileSize = eiros_journald.retention.max_file_size;
      MaxRetentionSec = eiros_journald.retention.max_retention_sec;
      RateLimitIntervalSec = eiros_journald.rate_limit.interval_sec;
      RateLimitBurst = eiros_journald.rate_limit.burst;
    };

    systemd.services.eiros-journal-vacuum = lib.mkIf eiros_journald.vacuum.enable {
      description = "Eiros journal vacuum";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${config.systemd.package}/bin/journalctl --vacuum-size=${eiros_journald.vacuum.keep_free}";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.timers.eiros-journal-vacuum = lib.mkIf eiros_journald.vacuum.enable {
      description = "Eiros journal vacuum timer";
      after = [ "time-sync.target" ];
      requires = [ "time-sync.target" ];
      timerConfig = {
        OnCalendar = eiros_journald.vacuum.dates;
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
