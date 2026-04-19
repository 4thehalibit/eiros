# Installs imv as a lightweight Wayland-native image viewer with configurable MIME type associations.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_imv = config.eiros.system.default_applications.media.imv;
in
{
  options.eiros.system.default_applications.media.imv = {
    enable = lib.mkOption {
      default = true;
      description = "Install imv image viewer.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.imv.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    default_image_viewer.enable = lib.mkOption {
      default = true;
      description = "Use imv as the default application for image MIME types.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.imv.default_image_viewer.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.imv;
      description = "imv package to install.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.imv.package = pkgs.imv;
        }
      '';
      type = lib.types.package;
    };
  };

  config = lib.mkIf eiros_imv.enable {
    environment.systemPackages = [ eiros_imv.package ];

    xdg.mime.defaultApplications = lib.mkIf eiros_imv.default_image_viewer.enable {
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/x-tga" = "imv.desktop";
      "image/avif" = "imv.desktop";
      "image/heic" = "imv.desktop";
    };
  };
}
