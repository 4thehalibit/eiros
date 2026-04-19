# Installs btop, a TUI system resource monitor for CPU, memory, disk, network, and processes.
{ config, lib, pkgs, ... }:
let
  eiros_btop = config.eiros.system.default_applications.system_monitoring.btop;
in
{
  options.eiros.system.default_applications.system_monitoring.btop.enable = lib.mkOption {
    default = true;
    description = "Install btop system resource monitor.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.system_monitoring.btop.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_btop.enable {
    environment.systemPackages = [ pkgs.btop ];
  };
}
