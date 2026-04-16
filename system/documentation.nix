# Controls installation of man pages and optional NixOS option documentation.
{ config, lib, ... }:
let
  eiros_documentation = config.eiros.system.documentation;
in
{
  options.eiros.system.documentation = {
    man.enable = lib.mkOption {
      default = true;
      description = "Install man pages for system packages.";
      example = false;
      type = lib.types.bool;
    };

    nixos.enable = lib.mkOption {
      default = false;
      description = "Install NixOS option documentation (large closure, off by default).";
      example = true;
      type = lib.types.bool;
    };
  };

  config = {
    documentation = {
      man.enable = eiros_documentation.man.enable;
      nixos.enable = eiros_documentation.nixos.enable;
    };
  };
}
