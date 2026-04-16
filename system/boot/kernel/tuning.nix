# Applies kernel boot parameters and sysctl settings for CPU, VM, and I/O performance tuning.
{ config, lib, ... }:
let
  eiros_tuning = config.eiros.system.boot.kernel.tuning;
in
{
  options.eiros.system.boot.kernel.tuning = {
    enable = lib.mkOption {
      default = true;
      description = "Enable kernel parameter and sysctl performance tuning.";
      example = false;
      type = lib.types.bool;
    };

    kernel_params = lib.mkOption {
      default = [
        "transparent_hugepage=madvise"
        "nvme_core.default_ps_max_latency_us=0"
        "iommu=pt"
        "threadirqs"
      ];
      description = "Kernel parameters for performance tuning.";
      example = [
        "quiet"
        "mitigations=off"
      ];
      type = lib.types.listOf lib.types.str;
    };

    sysctl = {
      enable = lib.mkOption {
        default = true;
        description = "Enable sysctl VM and scheduler tuning.";
        example = false;
        type = lib.types.bool;
      };

      settings = lib.mkOption {
        default = {
          "vm.swappiness" = 0;
          "vm.vfs_cache_pressure" = 50;
          "vm.dirty_ratio" = 10;
          "vm.dirty_background_ratio" = 5;
          "vm.dirty_writeback_centisecs" = 1500;
          "vm.oom_kill_allocating_task" = 1;
          "kernel.sched_migration_cost_ns" = 5000000;
          "kernel.nmi_watchdog" = 0;
        };
        description = "Sysctl settings for VM and scheduler tuning.";
        example = lib.literalExpression ''{ "vm.swappiness" = 10; "vm.vfs_cache_pressure" = 100; }'';
        type = lib.types.attrsOf lib.types.anything;
      };
    };
  };

  config = lib.mkIf eiros_tuning.enable {
    boot.kernelParams = eiros_tuning.kernel_params;

    boot.kernel.sysctl = lib.mkIf eiros_tuning.sysctl.enable eiros_tuning.sysctl.settings;
  };
}
