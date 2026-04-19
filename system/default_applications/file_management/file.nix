# Installs the file utility for determining file types from magic bytes.
{ config, lib, pkgs, ... }:
let
  eiros_file = config.eiros.system.default_applications.file_management.file;
in
{
  options.eiros.system.default_applications.file_management.file.enable = lib.mkOption {
    default = true;
    description = "Install file for determining file types.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.file_management.file.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_file.enable {
    environment.systemPackages = [ pkgs.file ];
  };
}
