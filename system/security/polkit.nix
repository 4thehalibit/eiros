# Enables the Polkit authorization framework for privileged D-Bus actions.
{ config, lib, ... }:
let
  eiros_polkit = config.eiros.system.security.polkit;
in
{
  options.eiros.system.security.polkit = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Polkit.";
      example = false;
      type = lib.types.bool;
    };
  };

  config.security.polkit.enable = eiros_polkit.enable;
}
