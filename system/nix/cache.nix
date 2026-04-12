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
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];

      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
