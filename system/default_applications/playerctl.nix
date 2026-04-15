{ config, lib, pkgs, ... }:
let
  eiros_playerctl = config.eiros.system.default_applications.playerctl;
in
{
  options.eiros.system.default_applications.playerctl.enable = lib.mkOption {
    default = true;
    description = "Install playerctl for media playback control.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_playerctl.enable {
    environment.systemPackages = [ pkgs.playerctl ];
  };
}
