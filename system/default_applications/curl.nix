{ config, lib, pkgs, ... }:
let
  eiros_curl = config.eiros.system.default_applications.curl;
in
{
  options.eiros.system.default_applications.curl.enable = lib.mkOption {
    default = true;
    description = "Install curl for command-line HTTP/HTTPS transfers.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_curl.enable {
    environment.systemPackages = [ pkgs.curl ];
  };
}
