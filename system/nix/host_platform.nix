# Sets the nixpkgs host platform (CPU architecture and OS) for the build.
{ config, lib, ... }:
let
  eiros_nix = config.eiros.system.nix;
in
{
  options.eiros.system.nix = {
    host_platform = lib.mkOption {
      default = "x86_64-linux";
      description = "The platform that the Nix daemon is running on.";
      example = "aarch64-linux";
      type = lib.types.enum [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
  };

  config.nixpkgs.hostPlatform = eiros_nix.host_platform;
}
