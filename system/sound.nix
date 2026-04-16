# Configures PipeWire audio stack and installs sound-related tools and applications.
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
        example = lib.literalExpression ''
          {
            eiros.system.sound.pactl.enable = false;
          }
        '';
        type = lib.types.bool;
      };
    };

    playerctl = {
      enable = lib.mkOption {
        default = true;
        description = "Install playerctl for media playback control.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.playerctl.enable = false;
          }
        '';
        type = lib.types.bool;
      };
    };

    pipewire = {
      alsa = {
        enable = lib.mkOption {
          default = true;
          description = "Enable ALSA support for PipeWire.";
          example = lib.literalExpression ''
            {
              eiros.system.sound.pipewire.alsa.enable = false;
            }
          '';
          type = lib.types.bool;
        };

        support_32_bit = lib.mkOption {
          default = true;
          description = "Enable 32-bit ALSA support (useful for Steam/Wine).";
          example = lib.literalExpression ''
            {
              eiros.system.sound.pipewire.alsa.support_32_bit = false;
            }
          '';
          type = lib.types.bool;
        };
      };

      enable = lib.mkOption {
        default = true;
        description = "Enable PipeWire.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.pipewire.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      jack.enable = lib.mkOption {
        default = false;
        description = "Enable PipeWire JACK support.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.pipewire.jack.enable = true;
          }
        '';
        type = lib.types.bool;
      };

      pulse.enable = lib.mkOption {
        default = true;
        description = "Enable PipeWire PulseAudio compatibility layer.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.pipewire.pulse.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      rtkit.enable = lib.mkOption {
        default = true;
        description = "Enable RTKit for real-time audio scheduling.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.pipewire.rtkit.enable = false;
          }
        '';
        type = lib.types.bool;
      };
    };

    helvum = {
      enable = lib.mkOption {
        default = false;
        description = "Install Helvum, a GTK patchbay GUI for managing PipeWire audio/video routing.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.helvum.enable = true;
          }
        '';
        type = lib.types.bool;
      };
    };

    easyeffects = {
      enable = lib.mkOption {
        default = false;
        description = "Install EasyEffects for PipeWire audio effects and equalisation.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.easyeffects.enable = true;
          }
        '';
        type = lib.types.bool;
      };

      autostart.enable = lib.mkOption {
        default = true;
        description = "Start EasyEffects automatically as a systemd user service on login.";
        example = lib.literalExpression ''
          {
            eiros.system.sound.easyeffects.autostart.enable = false;
          }
        '';
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

    (lib.mkIf eiros_sound.pipewire.enable {
      assertions = [
        {
          assertion = !config.services.pulseaudio.enable;
          message = "eiros.system.sound.pipewire.enable requires services.pulseaudio.enable = false";
        }
      ];

      services = {
        pipewire = {
          enable = true;

          alsa = {
            enable = eiros_sound.pipewire.alsa.enable;
            support32Bit = eiros_sound.pipewire.alsa.support_32_bit;
          };

          jack = {
            enable = eiros_sound.pipewire.jack.enable;
          };

          pulse = {
            enable = eiros_sound.pipewire.pulse.enable;
          };
        };

        pulseaudio = {
          enable = false;
        };
      };

      security = {
        rtkit = {
          enable = eiros_sound.pipewire.rtkit.enable;
        };
      };
    })

    (lib.mkIf eiros_sound.helvum.enable {
      environment.systemPackages = [ pkgs.helvum ];
    })

    (lib.mkIf eiros_sound.easyeffects.enable {
      environment.systemPackages = [ pkgs.easyeffects ];

      systemd.user.services.easyeffects = lib.mkIf eiros_sound.easyeffects.autostart.enable {
        description = "EasyEffects PipeWire audio effects service";
        wantedBy = [ "default.target" ];
        after = [ "pipewire.service" "pipewire-pulse.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
          Restart = "on-failure";
        };
      };
    })
  ];
}
