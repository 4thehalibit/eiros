# Installs gping, a ping tool with a real-time ASCII graph for visualizing latency.
{ config, lib, pkgs, ... }:
let
  eiros_gping = config.eiros.system.default_applications.system_monitoring.gping;
in
{
  options.eiros.system.default_applications.system_monitoring.gping.enable = lib.mkOption {
    default = true;
    description = "Install gping, a ping tool with real-time ASCII graph and multi-host support.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.system_monitoring.gping.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_gping.enable {
    environment.systemPackages = [ pkgs.gping ];
  };
}
