# Configures systemd-logind lid, power button, and idle behaviour.
{ config, lib, ... }:
let
  eiros_logind = config.eiros.system.hardware.logind;
in
{
  options.eiros.system.hardware.logind = {
    enable = lib.mkOption {
      default = true;
      description = "Configure systemd-logind lid, power button, and idle behaviour.";
      example = false;
      type = lib.types.bool;
    };

    lid_switch = lib.mkOption {
      default = "suspend";
      description = "Action when the lid is closed on battery (suspend, lock, ignore, hibernate, poweroff).";
      example = "lock";
      type = lib.types.enum [ "suspend" "lock" "ignore" "hibernate" "poweroff" ];
    };

    lid_switch_external_power = lib.mkOption {
      default = "lock";
      description = "Action when the lid is closed on external power (suspend, lock, ignore, hibernate, poweroff).";
      example = "ignore";
      type = lib.types.enum [ "suspend" "lock" "ignore" "hibernate" "poweroff" ];
    };

    power_key = lib.mkOption {
      default = "suspend";
      description = "Action when the power button is pressed (suspend, lock, ignore, hibernate, poweroff).";
      example = "poweroff";
      type = lib.types.enum [ "suspend" "lock" "ignore" "hibernate" "poweroff" ];
    };

    idle_action = lib.mkOption {
      default = "suspend";
      description = "Action taken after idle_timeout_sec of inactivity (suspend, lock, ignore, hibernate, poweroff).";
      example = "lock";
      type = lib.types.enum [ "suspend" "lock" "ignore" "hibernate" "poweroff" ];
    };

    idle_timeout_sec = lib.mkOption {
      default = 600;
      description = "Seconds of inactivity before idle_action is triggered.";
      example = 300;
      type = lib.types.int;
    };
  };

  config = lib.mkIf eiros_logind.enable {
    assertions = [
      {
        assertion = eiros_logind.idle_timeout_sec > 0;
        message = "eiros.system.hardware.logind.idle_timeout_sec must be greater than 0.";
      }
    ];

    services.logind.settings.Login = {
      HandleLidSwitch = eiros_logind.lid_switch;
      HandleLidSwitchExternalPower = eiros_logind.lid_switch_external_power;
      HandlePowerKey = eiros_logind.power_key;
      IdleAction = eiros_logind.idle_action;
      IdleActionSec = eiros_logind.idle_timeout_sec;
    };
  };
}
