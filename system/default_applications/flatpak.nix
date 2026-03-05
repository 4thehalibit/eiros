{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.eiros.system.default_applications.flatpak;

  discoverPkg =
    if pkgs ? kdePackages && pkgs.kdePackages ? discover then
      pkgs.kdePackages.discover
    else if pkgs ? discover then
      pkgs.discover
    else
      null;
in
{
  options.eiros.system.default_applications.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Flatpak support.";
    };

    discover = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install KDE Discover for managing Flatpak applications.";
    };
  };

  config = lib.mkIf cfg.enable {

    services.flatpak.enable = true;

    # Discover support
    services.packagekit.enable = lib.mkIf cfg.discover true;

    environment.systemPackages = lib.optionals cfg.discover (
      lib.optionals (discoverPkg != null) [ discoverPkg ]
    );

    # Flathub remote (exact method from NixOS documentation)
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

  };
}
