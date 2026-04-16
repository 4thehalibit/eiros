# Configures CPU frequency scaling, UPower, and optional power-profiles-daemon.
{ config, lib, ... }:
let
  eiros_power = config.eiros.system.hardware.power;
in
{
  options.eiros.system.hardware.power = {
    upower.enable = lib.mkOption {
      default = true;
      description = "Enable UPower for power management.";
      example = false;
      type = lib.types.bool;
    };

    cpu_governor = lib.mkOption {
      default = "schedutil";
      description = "CPU frequency scaling governor. Set to null when using power_profiles (power-profiles-daemon). schedutil is recommended for modern kernels as it hooks directly into the scheduler.";
      example = "performance";
      type = lib.types.nullOr lib.types.str;
    };

    power_profiles.enable = lib.mkOption {
      default = false;
      description = "Enable power-profiles-daemon for dynamic CPU power profiles (performance, balanced, power-saver). Integrates with the DMS control center. Incompatible with cpu_governor — set that to null when enabling this.";
      example = true;
      type = lib.types.bool;
    };
  };

  config = {
    assertions = lib.optional eiros_power.power_profiles.enable {
      assertion = config.powerManagement.cpuFreqGovernor == null;
      message = "power_profiles is enabled but powerManagement.cpuFreqGovernor is set. Set eiros.system.hardware.power.cpu_governor to null to avoid conflicts.";
    };

    services.upower.enable = eiros_power.upower.enable;
    powerManagement.cpuFreqGovernor = lib.mkDefault eiros_power.cpu_governor;

    services.power-profiles-daemon.enable = lib.mkIf eiros_power.power_profiles.enable true;
  };
}
