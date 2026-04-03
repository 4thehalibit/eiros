{ config, lib, ... }:
let
  eiros_gc = config.eiros.system.nix.garbage_collection;
in
{
  options.eiros.system.nix.garbage_collection = {
    enable = lib.mkOption {
      default = true;
      description = "Enable sane Nix garbage collection defaults.";
      type = lib.types.bool;
    };

    dates = lib.mkOption {
      default = "daily";
      description = "systemd OnCalendar schedule for nix-gc.";
      type = lib.types.str;
    };

    delete_older_than = lib.mkOption {
      default = "14d";
      description = "Delete generations older than this (nix-collect-garbage --delete-older-than).";
      type = lib.types.str;
    };

    auto_optimise_store.enable = lib.mkOption {
      default = true;
      description = "Enable automatic Nix store optimisation (dedup/optimise).";
      type = lib.types.bool;
    };

    disk_pressure = {
      min_free = lib.mkOption {
        default = 5 * 1024 * 1024 * 1024;
        description = "Trigger GC when free space drops below this many bytes.";
        type = lib.types.int;
      };

      max_free = lib.mkOption {
        default = 20 * 1024 * 1024 * 1024;
        description = "GC until free space reaches this many bytes.";
        type = lib.types.int;
      };
    };
  };

  config = lib.mkIf eiros_gc.enable {
    nix = {
      gc = {
        automatic = true;
        dates = eiros_gc.dates;
        options = "--delete-older-than ${eiros_gc.delete_older_than}";
      };

      settings = {
        auto-optimise-store = eiros_gc.auto_optimise_store.enable;

        # Disk pressure GC: Nix will try to GC when low on space.
        min-free = eiros_gc.disk_pressure.min_free;
        max-free = eiros_gc.disk_pressure.max_free;
      };
    };
  };
}
