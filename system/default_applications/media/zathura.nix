# Installs zathura as a keyboard-driven PDF and document viewer with configurable MIME type associations.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_zathura = config.eiros.system.default_applications.media.zathura;
in
{
  options.eiros.system.default_applications.media.zathura = {
    enable = lib.mkOption {
      default = true;
      description = "Install zathura document viewer.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.zathura.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    default_pdf_viewer.enable = lib.mkOption {
      default = true;
      description = "Use zathura as the default application for PDF and document MIME types.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.zathura.default_pdf_viewer.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.zathura;
      description = "zathura package to install.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.zathura.package = pkgs.zathura;
        }
      '';
      type = lib.types.package;
    };
  };

  config = lib.mkIf eiros_zathura.enable {
    environment.systemPackages = [ eiros_zathura.package ];

    xdg.mime.defaultApplications = lib.mkIf eiros_zathura.default_pdf_viewer.enable {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/postscript" = "org.pwmt.zathura.desktop";
      "image/vnd.djvu" = "org.pwmt.zathura.desktop";
    };
  };
}
