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
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf eiros_sound.pactl.enable {
    environment.systemPackages = [ pkgs.pulseaudio ];
  };
}
