# Installs wget for non-interactive command-line file downloading.
{ config, lib, pkgs, ... }:
let
  eiros_wget = config.eiros.system.default_applications.network.wget;
in
{
  options.eiros.system.default_applications.network.wget.enable = lib.mkOption {
    default = true;
    description = "Install wget for command-line file downloading.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.network.wget.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_wget.enable {
    environment.systemPackages = [ pkgs.wget ];
  };
}
