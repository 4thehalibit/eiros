# Installs curl for command-line HTTP/HTTPS transfers.
{ config, lib, pkgs, ... }:
let
  eiros_curl = config.eiros.system.default_applications.network.curl;
in
{
  options.eiros.system.default_applications.network.curl.enable = lib.mkOption {
    default = true;
    description = "Install curl for command-line HTTP/HTTPS transfers.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.network.curl.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_curl.enable {
    environment.systemPackages = [ pkgs.curl ];
  };
}
