{ config, lib, ... }:
let
  eiros_dconf = config.eiros.system.desktop_environment.dconf;
in
{
  options.eiros.system.desktop_environment.dconf.enable = lib.mkOption {
    default = true;
    description = "Enable the dconf settings daemon. Required by GTK applications and Seahorse to persist settings.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_dconf.enable {
    programs.dconf.enable = true;
  };
}
