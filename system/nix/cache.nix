{ config, lib, ... }:
let
  eiros_cache = config.eiros.system.nix.cache;
in
{
  options.eiros.system.nix.cache = {
    enable = lib.mkOption {
      default = true;
      description = "Enable binary cache substituters for faster builds.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_cache.enable {
    nix.settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dde0enMB6ox56g4OKZaD7hj5CnqCZhH5Y="
      ];
    };
  };
}
