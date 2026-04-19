# Installs unzip for extracting ZIP archives.
{ config, lib, pkgs, ... }:
let
  eiros_unzip = config.eiros.system.default_applications.file_management.unzip;
in
{
  options.eiros.system.default_applications.file_management.unzip.enable = lib.mkOption {
    default = true;
    description = "Install unzip for extracting ZIP archives.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.file_management.unzip.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_unzip.enable {
    environment.systemPackages = [ pkgs.unzip ];
  };
}
