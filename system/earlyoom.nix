# Enables earlyoom to kill memory-hungry processes before the kernel OOM freezes the system.
{ config, lib, ... }:
let
  eiros_earlyoom = config.eiros.system.earlyoom;
in
{
  options.eiros.system.earlyoom = {
    enable = lib.mkOption {
      default = true;
      description = "Enable earlyoom to prevent system freezes under memory pressure.";
      example = lib.literalExpression ''
        {
          eiros.system.earlyoom.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    free_mem_threshold = lib.mkOption {
      default = 10;
      description = "Kill processes when free memory drops below this percentage.";
      example = lib.literalExpression ''
        {
          eiros.system.earlyoom.free_mem_threshold = 5;
        }
      '';
      type = lib.types.int;
    };

    free_swap_threshold = lib.mkOption {
      default = 10;
      description = "Kill processes when free swap drops below this percentage.";
      example = lib.literalExpression ''
        {
          eiros.system.earlyoom.free_swap_threshold = 5;
        }
      '';
      type = lib.types.int;
    };

    extra_args = lib.mkOption {
      default = [ "--prefer '(^|/)(firefox|chromium|vivaldi)$'" ];
      description = "Extra arguments passed to earlyoom (e.g. --prefer or --avoid patterns).";
      example = lib.literalExpression ''
        {
          eiros.system.earlyoom.extra_args = [ "--avoid '(^|/)(init|systemd)$'" ];
        }
      '';
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf eiros_earlyoom.enable {
    services.earlyoom = {
      enable = true;
      freeMemThreshold = eiros_earlyoom.free_mem_threshold;
      freeSwapThreshold = eiros_earlyoom.free_swap_threshold;
      extraArgs = eiros_earlyoom.extra_args;
    };
  };
}
