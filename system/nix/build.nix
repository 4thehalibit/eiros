{ config, lib, ... }:
let
  eiros_build = config.eiros.system.nix.build;
in
{
  options.eiros.system.nix.build = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Nix build performance settings.";
      type = lib.types.bool;
    };

    max_jobs = lib.mkOption {
      default = "auto";
      description = "Number of parallel Nix build jobs. \"auto\" uses all available CPU cores.";
      type = lib.types.either lib.types.int (lib.types.enum [ "auto" ]);
    };

    cores = lib.mkOption {
      default = 0;
      description = "CPU cores per build job. 0 means use all available cores.";
      type = lib.types.int;
    };

    keep_outputs = lib.mkOption {
      default = true;
      description = "Keep build outputs in the store even after GC. Prevents re-downloading sources and build tools during active development.";
      type = lib.types.bool;
    };

    keep_derivations = lib.mkOption {
      default = true;
      description = "Keep .drv derivation files in the store even after GC. Required for nix develop and nix-direnv to work correctly after a GC run.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_build.enable {
    nix.settings = {
      max-jobs = eiros_build.max_jobs;
      cores = eiros_build.cores;
      keep-outputs = eiros_build.keep_outputs;
      keep-derivations = eiros_build.keep_derivations;
    };
  };
}
