# Installs ripgrep (rg), a fast recursive regex search tool.
{ config, lib, pkgs, ... }:
let
  eiros_ripgrep = config.eiros.system.default_applications.ripgrep;
in
{
  options.eiros.system.default_applications.ripgrep.enable = lib.mkOption {
    default = true;
    description = "Install ripgrep (rg), a fast recursive grep replacement.";
    example = false;
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_ripgrep.enable {
    environment.systemPackages = [ pkgs.ripgrep ];
  };
}
