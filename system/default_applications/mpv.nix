# Installs mpv as the default media player with configurable MIME type associations.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_mpv = config.eiros.system.default_applications.mpv;
in
{
  options.eiros.system.default_applications.mpv = {
    enable = lib.mkOption {
      default = true;
      description = "Install mpv media player.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.mpv.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    default_media_player.enable = lib.mkOption {
      default = true;
      description = "Use mpv as the default application for video and audio MIME types.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.mpv.default_media_player.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.mpv;
      description = "mpv package to install.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.mpv.package = pkgs.mpv-unwrapped;
        }
      '';
      type = lib.types.package;
    };
  };

  config = lib.mkIf eiros_mpv.enable {
    environment.systemPackages = [ eiros_mpv.package ];

    xdg.mime.defaultApplications = lib.mkIf eiros_mpv.default_media_player.enable {
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/ogg" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/aac" = "mpv.desktop";
      "audio/mp4" = "mpv.desktop";
      "audio/x-flac" = "mpv.desktop";
      "audio/opus" = "mpv.desktop";
    };
  };
}
