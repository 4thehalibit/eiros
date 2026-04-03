{
  config,
  lib,
  pkgs,
  ...
}:

let
  eiros_flatpak = config.eiros.system.default_applications.flatpak;

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
      default = true;
      description = "Enable Flatpak support.";
      type = lib.types.bool;
    };

    discover = lib.mkOption {
      default = true;
      description = "Install KDE Discover for managing Flatpak applications.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_flatpak.enable {
    warnings = lib.optional (eiros_flatpak.discover && discoverPkg == null)
      "eiros: flatpak.discover = true but no Discover package found in pkgs";

    services.flatpak.enable = true;

    # Discover support
    services.packagekit.enable = eiros_flatpak.discover;

    environment.systemPackages = lib.optionals (eiros_flatpak.discover && discoverPkg != null) [ discoverPkg ];

    # Flathub remote (exact method from NixOS documentation)
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      path = [ pkgs.flatpak ];

      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
