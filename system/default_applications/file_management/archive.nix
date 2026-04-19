# Installs archive creation tools (zip, p7zip) to complement the existing unzip module.
{ config, lib, pkgs, ... }:
let
  eiros_archive = config.eiros.system.default_applications.file_management.archive;
in
{
  options.eiros.system.default_applications.file_management.archive = {
    enable = lib.mkOption {
      default = true;
      description = "Install archive creation tools.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.archive.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    zip.enable = lib.mkOption {
      default = true;
      description = "Install zip for creating and managing .zip archives.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.archive.zip.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    p7zip.enable = lib.mkOption {
      default = true;
      description = "Install p7zip (7z) for creating and extracting .7z, .zip, .tar, and many other archive formats.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.archive.p7zip.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_archive.enable {
    environment.systemPackages =
      lib.optionals eiros_archive.zip.enable [ pkgs.zip ]
      ++ lib.optionals eiros_archive.p7zip.enable [ pkgs.p7zip ];
  };
}
