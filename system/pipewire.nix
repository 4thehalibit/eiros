# Configures PipeWire with ALSA, PulseAudio compatibility, optional JACK, and RTKit scheduling.
{ config, lib, ... }:
let
  eiros_pipewire = config.eiros.system.pipewire;
in
{
  options.eiros.system.pipewire = {
    alsa = {
      enable = lib.mkOption {
        default = true;
        description = "Enable ALSA support for PipeWire.";
        example = false;
        type = lib.types.bool;
      };

      support_32_bit = lib.mkOption {
        default = true;
        description = "Enable 32-bit ALSA support (useful for Steam/Wine).";
        example = false;
        type = lib.types.bool;
      };
    };

    enable = lib.mkOption {
      default = true;
      description = "Enable PipeWire.";
      example = false;
      type = lib.types.bool;
    };

    jack.enable = lib.mkOption {
      default = false;
      description = "Enable PipeWire JACK support.";
      example = true;
      type = lib.types.bool;
    };

    pulse.enable = lib.mkOption {
      default = true;
      description = "Enable PipeWire PulseAudio compatibility layer.";
      example = false;
      type = lib.types.bool;
    };

    rtkit.enable = lib.mkOption {
      default = true;
      description = "Enable RTKit for real-time audio scheduling.";
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_pipewire.enable {
    assertions = [
      {
        assertion = !config.services.pulseaudio.enable;
        message = "eiros.system.pipewire.enable requires services.pulseaudio.enable = false";
      }
    ];

    services = {
      pipewire = {
        enable = true;

        alsa = {
          enable = eiros_pipewire.alsa.enable;
          support32Bit = eiros_pipewire.alsa.support_32_bit;
        };

        jack = {
          enable = eiros_pipewire.jack.enable;
        };

        pulse = {
          enable = eiros_pipewire.pulse.enable;
        };
      };

      pulseaudio = {
        enable = false;
      };
    };

    security = {
      rtkit = {
        enable = eiros_pipewire.rtkit.enable;
      };
    };
  };
}
