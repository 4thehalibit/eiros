# Installs gping, a ping tool with a real-time ASCII graph for visualizing latency.
{ config, lib, pkgs, ... }:
let
  eiros_gping = config.eiros.system.default_applications.system_monitoring.gping;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.system_monitoring.gping = {
    enable = lib.mkOption {
      default = true;
      description = "Install gping, a ping tool with real-time ASCII graph and multi-host support.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.system_monitoring.gping.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    override.enable = lib.mkOption {
      default = true;
      description = "Alias ping to gping so gping is used transparently in place of ping.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.system_monitoring.gping.override.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_gping.enable {
    environment.systemPackages = [ pkgs.gping ];

    programs.zsh.shellAliases = lib.mkIf (eiros_zsh.enable && eiros_gping.override.enable) {
      ping = "gping";
    };
  };
}
