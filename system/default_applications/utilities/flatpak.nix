# Enables Flatpak support with optional KDE Discover integration and Flathub remote registration.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  eiros_flatpak = config.eiros.system.default_applications.utilities.flatpak;

  discoverPkg =
    if pkgs ? kdePackages && pkgs.kdePackages ? discover then
      pkgs.kdePackages.discover
    else if pkgs ? discover then
      pkgs.discover
    else
      null;
in
{
  options.eiros.system.default_applications.utilities.flatpak = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Flatpak support.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.utilities.flatpak.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    discover = lib.mkOption {
      default = true;
      description = "Install KDE Discover for managing Flatpak applications.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.utilities.flatpak.discover = false;
        }
      '';
      type = lib.types.bool;
    };

    flathub_url = lib.mkOption {
      default = "https://flathub.org/repo/flathub.flatpakrepo";
      description = "URL of the Flathub repository file to register as a Flatpak remote.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.utilities.flatpak.flathub_url = "https://flathub.org/repo/flathub.flatpakrepo";
        }
      '';
      type = lib.types.str;
    };
  };

  config = lib.mkIf eiros_flatpak.enable {
    warnings = lib.optional (eiros_flatpak.discover && discoverPkg == null)
      "eiros: flatpak.discover = true but no Discover package found in pkgs";

    services.flatpak.enable = true;

    services.packagekit.enable = eiros_flatpak.discover;

    environment.systemPackages = lib.optionals (eiros_flatpak.discover && discoverPkg != null) [ discoverPkg ];

    # Register Flathub as a system-wide Flatpak remote on first boot.
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      path = [ pkgs.flatpak ];

      script = ''
        flatpak remote-add --if-not-exists flathub ${eiros_flatpak.flathub_url}
      '';
    };
  };
}
