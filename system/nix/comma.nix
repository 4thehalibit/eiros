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
      example = false;
      type = lib.types.bool;
    };

    nix_index.enable = lib.mkOption {
      default = true;
      description = "Install nix-index and run nix-index to build the file database. Required for comma to resolve package names.";
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_comma.enable {
    environment.systemPackages =
      [ pkgs.comma ]
      ++ lib.optionals eiros_comma.nix_index.enable [ pkgs.nix-index ];

    programs.nix-index = lib.mkIf eiros_comma.nix_index.enable {
      enable = true;
      enableZshIntegration = config.eiros.system.default_applications.zsh.enable;
    };
  };
}
