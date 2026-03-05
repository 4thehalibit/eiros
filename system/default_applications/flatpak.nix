{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.eiros.system.default_applications.flatpak;
in
{
  options.eiros.system.default_applications.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Flatpak support.";
    };
  };

  config = lib.mkIf cfg.enable {

    services.flatpak.enable = true;

    systemd.services.flatpak-repo = {
      description = "Add Flathub Flatpak remote";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      path = [
        pkgs.flatpak
        pkgs.curl
        pkgs.coreutils
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        Restart = "on-failure";
        RestartSec = "10s";
        StartLimitIntervalSec = 0;
      };

      script = ''
        set -euo pipefail

        echo "Waiting for network access..."

        for i in $(seq 1 30); do
          if curl -fsSL --max-time 5 https://flathub.org/ >/dev/null; then
            echo "Network ready."
            break
          fi
          echo "Network/DNS not ready (attempt $i/30)"
          sleep 10
        done

        curl -fsSL --max-time 10 https://flathub.org/repo/flathub.flatpakrepo >/dev/null

        flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

        echo "Flathub remote ensured."
      '';
    };

  };
}
