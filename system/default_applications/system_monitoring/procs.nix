# Installs procs, a modern ps replacement written in Rust with colored output and tree view.
{ config, lib, pkgs, ... }:
let
  eiros_procs = config.eiros.system.default_applications.system_monitoring.procs;
in
{
  options.eiros.system.default_applications.system_monitoring.procs.enable = lib.mkOption {
    default = true;
    description = "Install procs, a modern ps replacement with colored output, tree view, and port display.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.system_monitoring.procs.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_procs.enable {
    environment.systemPackages = [ pkgs.procs ];
  };
}
