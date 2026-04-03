{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_virtualization = config.eiros.system.virtualization;
  eiros_podman = eiros_virtualization.podman;

  composePkg =
    if eiros_podman.compose.provider == "podman-compose" then pkgs.podman-compose else pkgs.docker-compose;
in
{
  options.eiros.system.virtualization.podman = {
    enable = lib.mkOption {
      default = true;
      description = "Enable podman.";
      type = lib.types.bool;
    };

    compose = {
      enable = lib.mkOption {
        default = true;
        description = "Install a compose provider so `podman compose` / `podman-compose` works.";
        type = lib.types.bool;
      };

      provider = lib.mkOption {
        default = "podman-compose";
        description = ''
          Which compose provider to install.

          - "podman-compose": python-based tool (`podman-compose ...`)
          - "docker-compose": Docker Compose v2 binary (`podman compose ...` can use it as provider)
        '';
        type = lib.types.enum [
          "podman-compose"
          "docker-compose"
        ];
      };
    };
  };

  config = lib.mkIf eiros_virtualization.enable (
    lib.mkMerge [
      # Podman baseline
      (lib.mkIf eiros_podman.enable {
        virtualisation = {
          containers = {
            enable = true;
          };
          podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
          };
        };
      })

      # Compose provider installation
      (lib.mkIf (eiros_podman.enable && eiros_podman.compose.enable) {
        environment.systemPackages = [ composePkg ];
      })
    ]
  );
}
