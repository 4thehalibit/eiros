# Installs duf, a modern disk usage viewer (df replacement) with colored output.
{ config, lib, pkgs, ... }:
let
  eiros_duf = config.eiros.system.default_applications.system_monitoring.duf;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.system_monitoring.duf = {
    enable = lib.mkOption {
      default = true;
      description = "Install duf, a modern df replacement with colored output and sorting.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.system_monitoring.duf.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    override.enable = lib.mkOption {
      default = true;
      description = "Alias df to duf so duf is used transparently in place of df.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.system_monitoring.duf.override.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_duf.enable {
    environment.systemPackages = [ pkgs.duf ];

    programs.zsh.shellAliases = lib.mkIf (eiros_zsh.enable && eiros_duf.override.enable) {
      df = "duf";
    };
  };
}
