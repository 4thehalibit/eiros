# Installs GStreamer multimedia framework and codec plugins for media playback and portal screen sharing.
{ config, lib, pkgs, ... }:
let
  eiros_multimedia = config.eiros.system.default_applications.media.multimedia;
in
{
  options.eiros.system.default_applications.media.multimedia = {
    enable = lib.mkOption {
      default = true;
      description = "Install GStreamer multimedia framework and codec plugins. Required for media playback in GTK applications, XDG portal screen sharing, and general multimedia support on a wlroots Wayland desktop.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.multimedia.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    packages = lib.mkOption {
      default = with pkgs.gst_all_1; [
        gstreamer
        gst-plugins-base
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
        gst-libav
      ];
      description = "GStreamer packages to install. Override to add or remove codec plugin sets.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.media.multimedia.packages = with pkgs.gst_all_1; [
            gstreamer
            gst-plugins-base
            gst-plugins-good
          ];
        }
      '';
      type = lib.types.listOf lib.types.package;
    };
  };

  config = lib.mkIf eiros_multimedia.enable {
    environment.systemPackages = eiros_multimedia.packages;
  };
}
