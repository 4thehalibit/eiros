# Installs tealdeer, a fast Rust implementation of tldr for simplified command examples.
{ config, lib, pkgs, ... }:
let
  eiros_tealdeer = config.eiros.system.default_applications.utilities.tealdeer;
in
{
  options.eiros.system.default_applications.utilities.tealdeer.enable = lib.mkOption {
    default = true;
    description = "Install tealdeer (tldr), a fast Rust client for community-maintained command examples.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.utilities.tealdeer.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_tealdeer.enable {
    environment.systemPackages = [ pkgs.tealdeer ];
  };
}
