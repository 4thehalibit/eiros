# Enables the Nix flakes and nix-command experimental features.
{ config, lib, ... }:
let
  eiros_nix = config.eiros.system.nix;
in
{
  options.eiros.system.nix.flake = {
    enable = lib.mkOption {
      default = true;
      description = "Enable flakes in Eiros.";
      example = false;
      type = lib.types.bool;
    };
  };

  config.nix.settings = lib.mkIf eiros_nix.flake.enable {
    experimental-features = lib.mkBefore [
      "nix-command"
      "flakes"
    ];
  };
}
