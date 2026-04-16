# Sets I/O schedulers per device class via udev rules for NVMe, SSD, and HDD.
{ config, lib, ... }:
let
  eiros_io = config.eiros.system.hardware.io_scheduler;
  scheduler_type = lib.types.enum [ "none" "mq-deadline" "bfq" "kyber" ];
in
{
  options.eiros.system.hardware.io_scheduler = {
    enable = lib.mkOption {
      default = true;
      description = "Set I/O schedulers per device type via udev rules.";
      example = false;
      type = lib.types.bool;
    };

    nvme_scheduler = lib.mkOption {
      default = "none";
      description = "I/O scheduler for NVMe devices. 'none' is recommended as NVMe drives manage their own queues.";
      example = "mq-deadline";
      type = scheduler_type;
    };

    ssd_scheduler = lib.mkOption {
      default = "mq-deadline";
      description = "I/O scheduler for SATA SSDs. 'mq-deadline' provides low latency with bounded wait times.";
      example = "none";
      type = scheduler_type;
    };

    hdd_scheduler = lib.mkOption {
      default = "bfq";
      description = "I/O scheduler for HDDs. 'bfq' provides fair queuing optimised for rotational media.";
      example = "mq-deadline";
      type = scheduler_type;
    };
  };

  config = lib.mkIf eiros_io.enable {
    # Per-device scheduler rules applied via udev ACTION=="add|change" triggers.
    services.udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="${eiros_io.nvme_scheduler}"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="${eiros_io.ssd_scheduler}"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="${eiros_io.hdd_scheduler}"
    '';
  };
}
