{ config, lib, ... }:
let
  eiros_io = config.eiros.system.hardware.io_scheduler;
in
{
  options.eiros.system.hardware.io_scheduler = {
    enable = lib.mkOption {
      default = true;
      description = "Set I/O schedulers per device type via udev rules.";
      type = lib.types.bool;
    };

    nvme_scheduler = lib.mkOption {
      default = "none";
      description = "I/O scheduler for NVMe devices. 'none' is recommended as NVMe drives manage their own queues.";
      type = lib.types.str;
    };

    ssd_scheduler = lib.mkOption {
      default = "mq-deadline";
      description = "I/O scheduler for SATA SSDs. 'mq-deadline' provides low latency with bounded wait times.";
      type = lib.types.str;
    };

    hdd_scheduler = lib.mkOption {
      default = "bfq";
      description = "I/O scheduler for HDDs. 'bfq' provides fair queuing optimised for rotational media.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf eiros_io.enable {
    services.udev.extraRules = ''
      # NVMe: no scheduler — the drive manages its own queue.
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="${eiros_io.nvme_scheduler}"

      # SATA SSD: mq-deadline — low latency with bounded wait times.
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="${eiros_io.ssd_scheduler}"

      # HDD: bfq — fair queuing optimised for rotational media.
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="${eiros_io.hdd_scheduler}"
    '';
  };
}
