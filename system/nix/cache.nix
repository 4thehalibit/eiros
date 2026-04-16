# Configures additional binary cache substituters and their trusted public keys.
{ config, lib, ... }:
let
  eiros_cache = config.eiros.system.nix.cache;
in
{
  options.eiros.system.nix.cache = {
    enable = lib.mkOption {
      default = true;
      description = "Enable binary cache substituters for faster builds.";
      example = false;
      type = lib.types.bool;
    };

    substituters = lib.mkOption {
      default = [ "https://nix-community.cachix.org" ];
      description = "Binary cache substituter URLs.";
      example = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      type = lib.types.listOf lib.types.str;
    };

    trusted_public_keys = lib.mkOption {
      default = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      description = "Trusted public keys for the binary cache substituters.";
      example = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf eiros_cache.enable {
    nix.settings = {
      extra-substituters = eiros_cache.substituters;
      extra-trusted-public-keys = eiros_cache.trusted_public_keys;
    };
  };
}
