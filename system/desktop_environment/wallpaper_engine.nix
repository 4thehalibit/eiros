# Registers the dms-wallpaperengine DMS plugin for animated Steam Workshop wallpapers.
# Requires eiros.system.default_applications.linux_wallpaperengine.enable = true.
{
  config,
  lib,
  inputs,
  ...
}:
let
  wpe = config.eiros.system.desktop_environment.wallpaper_engine;
in
{
  options.eiros.system.desktop_environment.wallpaper_engine = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the DMS linux-wallpaperengine plugin for animated Steam Workshop wallpapers.";
      example = lib.literalExpression ''
        {
          eiros.system.desktop_environment.wallpaper_engine.enable = true;
        }
      '';
    };
  };

  config = lib.mkIf wpe.enable {
    assertions = [
      {
        assertion = config.eiros.system.default_applications.linux_wallpaperengine.enable;
        message = "wallpaper_engine requires eiros.system.default_applications.linux_wallpaperengine.enable = true";
      }
    ];

    eiros.system.desktop_environment.dank_material_shell.plugins.linux-wallpaper-engine = {
      src = inputs.dms_wallpaperengine;
    };
  };
}
