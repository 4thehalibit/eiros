# Installs procs, a modern ps replacement written in Rust with colored output and tree view.
{ config, lib, pkgs, ... }:
let
  eiros_procs = config.eiros.system.default_applications.system_monitoring.procs;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.system_monitoring.procs = {
    enable = lib.mkOption {
      default = true;
      description = "Install procs, a modern ps replacement with colored output, tree view, and port display.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.system_monitoring.procs.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    override.enable = lib.mkOption {
      default = true;
      description = "Alias ps to procs so procs is used transparently in place of ps.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.system_monitoring.procs.override.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_procs.enable {
    environment.systemPackages = [ pkgs.procs ];

    programs.zsh.shellAliases = lib.mkIf (eiros_zsh.enable && eiros_procs.override.enable) {
      ps = "procs";
    };
  };
}
