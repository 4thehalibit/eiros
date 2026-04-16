# Installs pactl and playerctl for volume and media playback control via keybinds.
{ config, lib, pkgs, ... }:
let
  eiros_sound = config.eiros.system.sound;
in
{
  options.eiros.system.sound = {
    pactl = {
      enable = lib.mkOption {
        default = true;
        description = "Install pactl for PulseAudio/PipeWire volume control via keybinds.";
        example = false;
        type = lib.types.bool;
      };
    };
    playerctl = {
      enable = lib.mkOption {
        default = true;
        description = "Install playerctl for media playback control.";
        example = false;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf eiros_sound.pactl.enable {
      environment.systemPackages = [ pkgs.pulseaudio ];
    })
    (lib.mkIf eiros_sound.playerctl.enable {
      environment.systemPackages = [ pkgs.playerctl ];
    })
  ];
}
