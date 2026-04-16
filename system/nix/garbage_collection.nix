# Configures automatic Nix GC, store optimisation, disk pressure limits, and generation pruning.
{ config, lib, pkgs, ... }:
let
  eiros_gc = config.eiros.system.nix.garbage_collection;
in
{
  options.eiros.system.nix.garbage_collection = {
    enable = lib.mkOption {
      default = true;
      description = "Enable sane Nix garbage collection defaults.";
      example = false;
      type = lib.types.bool;
    };

    dates = lib.mkOption {
      default = "daily";
      description = "systemd OnCalendar schedule for nix-gc.";
      example = "weekly";
      type = lib.types.str;
    };

    delete_older_than = lib.mkOption {
      default = "14d";
      description = "Delete generations older than this (nix-collect-garbage --delete-older-than).";
      example = "30d";
      type = lib.types.str;
    };

    optimise = {
      enable = lib.mkOption {
        default = true;
        description = "Enable scheduled Nix store optimisation (dedup/hard-link). Runs out-of-band rather than inline during builds.";
        example = false;
        type = lib.types.bool;
      };

      dates = lib.mkOption {
        default = [ "03:45" ];
        description = "systemd OnCalendar schedule for nix store optimisation.";
        example = [ "04:00" ];
        type = lib.types.listOf lib.types.str;
      };
    };

    keep_generations = lib.mkOption {
      default = 3;
      description = "Keep only this many recent system generations. Runs alongside GC to prevent the boot partition from filling up.";
      example = 5;
      type = lib.types.int;
    };

    disk_pressure = {
      min_free = lib.mkOption {
        default = 5 * 1024 * 1024 * 1024;
        description = "Trigger GC when free space drops below this many bytes.";
        example = lib.literalExpression "2 * 1024 * 1024 * 1024";
        type = lib.types.int;
      };

      max_free = lib.mkOption {
        default = 20 * 1024 * 1024 * 1024;
        description = "GC until free space reaches this many bytes.";
        example = lib.literalExpression "10 * 1024 * 1024 * 1024";
        type = lib.types.int;
      };
    };
  };

  config = lib.mkIf eiros_gc.enable {
    assertions = [
      {
        assertion = eiros_gc.disk_pressure.min_free < eiros_gc.disk_pressure.max_free;
        message = "eiros.system.nix.garbage_collection.disk_pressure.min_free must be less than max_free.";
      }
    ];
    nix = {
      gc = {
        automatic = true;
        dates = eiros_gc.dates;
        options = "--delete-older-than ${eiros_gc.delete_older_than}";
      };

      optimise = lib.mkIf eiros_gc.optimise.enable {
        automatic = true;
        dates = eiros_gc.optimise.dates;
      };

      settings = {
        min-free = eiros_gc.disk_pressure.min_free;
        max-free = eiros_gc.disk_pressure.max_free;
      };
    };

    # Prune old system generations before GC so freed store paths can actually be
    # deleted and the boot partition stays within keep_generations entries.
    systemd.services.nix-gc = {
      preStart = ''
        ${pkgs.nix}/bin/nix-env \
          -p /nix/var/nix/profiles/system \
          --delete-generations +${toString eiros_gc.keep_generations}
      '';
    };
  };
}
