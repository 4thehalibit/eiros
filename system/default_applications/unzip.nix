{ config, lib, pkgs, ... }:
let
  eiros_unzip = config.eiros.system.default_applications.unzip;
in
{
  options.eiros.system.default_applications.unzip.enable = lib.mkOption {
    default = true;
    description = "Install unzip for extracting ZIP archives.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_unzip.enable {
    environment.systemPackages = [ pkgs.unzip ];
  };
}
