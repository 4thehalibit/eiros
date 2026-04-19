# wallpaperCarousel DMS plugin — interactive 3D carousel for wallpaper selection.
# Keybind (SUPER+w) is declared in users/default_settings/mangowc/keybinds.nix alongside other DMS binds.
{ inputs, pkgs, ... }:
{
  eiros.system.desktop_environment.dankmaterialshell.plugins = {
    wallpaperCarousel = {
      enable = true;
      src = inputs.wallpaper_carousel;
    };
  };

  # WallpaperCarousel.qml imports Qt5Compat.GraphicalEffects, which is not in the
  # default quickshell/dms QML import path. Expose it via the env var that the
  # nixpkgs-patched qtdeclarative reads at startup.
  environment.variables.NIXPKGS_QT6_QML_IMPORT_PATH =
    "${pkgs.kdePackages.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}";
}
