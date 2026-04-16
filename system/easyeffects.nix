# Enables EasyEffects for system-wide PipeWire audio effects (EQ, compressor, reverb, etc.).
{ config, lib, pkgs, ... }:
let
  eiros_easyeffects = config.eiros.system.easyeffects;
in
{
  options.eiros.system.easyeffects = {
    enable = lib.mkOption {
      default = false;
      description = "Install EasyEffects for PipeWire audio effects and equalisation.";
      example = lib.literalExpression ''
        {
          eiros.system.easyeffects.enable = true;
        }
      '';
      type = lib.types.bool;
    };

    autostart.enable = lib.mkOption {
      default = true;
      description = "Start EasyEffects automatically as a systemd user service on login.";
      example = lib.literalExpression ''
        {
          eiros.system.easyeffects.autostart.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_easyeffects.enable {
    environment.systemPackages = [ pkgs.easyeffects ];

    systemd.user.services.easyeffects = lib.mkIf eiros_easyeffects.autostart.enable {
      description = "EasyEffects PipeWire audio effects service";
      wantedBy = [ "default.target" ];
      after = [ "pipewire.service" "pipewire-pulse.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
        Restart = "on-failure";
      };
    };
  };
}
