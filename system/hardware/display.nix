# Installs brightnessctl for keyboard-driven screen brightness control.
{ config, lib, pkgs, ... }:
let
  eiros_display = config.eiros.system.hardware.display;
in
{
  options.eiros.system.hardware.display = {
    brightnessctl = {
      enable = lib.mkOption {
        default = true;
        description = "Install brightnessctl for screen brightness control via keybinds.";
        example = false;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf eiros_display.brightnessctl.enable {
    environment.systemPackages = [ pkgs.brightnessctl ];
  };
}
