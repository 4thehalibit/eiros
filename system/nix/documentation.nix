# Controls installation of man pages and optional NixOS option documentation.
{ config, lib, ... }:
let
  eiros_documentation = config.eiros.system.nix.documentation;
in
{
  options.eiros.system.nix.documentation = {
    man.enable = lib.mkOption {
      default = true;
      description = "Install man pages for system packages.";
      example = lib.literalExpression ''
        {
          eiros.system.nix.documentation.man.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    nixos.enable = lib.mkOption {
      default = false;
      description = "Install NixOS option documentation (large closure, off by default).";
      example = lib.literalExpression ''
        {
          eiros.system.nix.documentation.nixos.enable = true;
        }
      '';
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
