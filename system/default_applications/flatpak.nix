{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_flatpak = config.eiros.system.default_applications.flatpak;
in
{
  options.eiros.system.default_applications.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Flatpak support.";
    };
  };

  config = lib.mkIf eiros_flatpak.enable {

    services.flatpak.enable = true;

    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
