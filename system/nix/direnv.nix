# Enables direnv and nix-direnv for automatic per-directory Nix shell activation.
{ config, lib, ... }:
let
  eiros_direnv = config.eiros.system.nix.direnv;
in
{
  options.eiros.system.nix.direnv = {
    enable = lib.mkOption {
      default = true;
      description = "Enable direnv for per-directory automatic environment activation.";
      example = false;
      type = lib.types.bool;
    };

    nix_direnv.enable = lib.mkOption {
      default = true;
      description = "Enable nix-direnv integration. Caches nix develop shells so direnv reloads are fast and GC-safe.";
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = eiros_direnv.nix_direnv.enable;
    };
  };
}
