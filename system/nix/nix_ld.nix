{ config, lib, ... }:
let
  eiros_nix_ld = config.eiros.system.nix.nix_ld;
in
{
  options.eiros.system.nix.nix_ld.enable = lib.mkOption {
    default = true;
    description = "Enable nix-ld, allowing unpatched binaries to run without manual patchelf. Useful with distrobox and Flatpak where pre-compiled binaries are common.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_nix_ld.enable {
    programs.nix-ld.enable = true;
  };
}
