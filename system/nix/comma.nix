# Installs comma and nix-index for running any nixpkgs program without installing it.
{ config, lib, pkgs, ... }:
let
  eiros_comma = config.eiros.system.nix.comma;
in
{
  options.eiros.system.nix.comma = {
    enable = lib.mkOption {
      default = true;
      description = "Install comma, allowing any nixpkgs program to be run without installing it (e.g. , cowsay hello).";
      example = lib.literalExpression ''
        {
          eiros.system.nix.comma.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    nix_index.enable = lib.mkOption {
      default = true;
      description = "Install nix-index and run nix-index to build the file database. Required for comma to resolve package names.";
      example = lib.literalExpression ''
        {
          eiros.system.nix.comma.nix_index.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_comma.enable {
    programs.nix-index-database = lib.mkIf eiros_comma.nix_index.enable {
      comma.enable = true;
    };

    environment.systemPackages = lib.optionals (!eiros_comma.nix_index.enable) [ pkgs.comma ];
  };
}
