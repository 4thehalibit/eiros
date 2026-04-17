{ config, lib, pkgs, ... }:
let
  eiros_lwe = config.eiros.system.default_applications.linux_wallpaperengine;
in
{
  options.eiros.system.default_applications.linux_wallpaperengine = {
    enable = lib.mkOption {
      default = true;
      description = "Install linux-wallpaperengine, a Linux renderer for Steam Workshop Wallpaper Engine scenes.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_lwe.enable {
    environment.systemPackages = [ pkgs.linux-wallpaperengine ];
  };
}
