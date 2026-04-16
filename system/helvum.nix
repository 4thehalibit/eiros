# Installs Helvum, a graphical PipeWire patchbay for routing audio and video streams.
{ config, lib, pkgs, ... }:
let
  eiros_helvum = config.eiros.system.helvum;
in
{
  options.eiros.system.helvum = {
    enable = lib.mkOption {
      default = false;
      description = "Install Helvum, a GTK patchbay GUI for managing PipeWire audio/video routing.";
      example = lib.literalExpression ''
        {
          eiros.system.helvum.enable = true;
        }
      '';
      type = lib.types.bool;
    };
  };

  config.environment.systemPackages = lib.mkIf eiros_helvum.enable [ pkgs.helvum ];
}
