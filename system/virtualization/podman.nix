# Configures Podman with optional Docker compatibility, DNS, and a compose provider.
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
      example = false;
      type = lib.types.bool;
    };

    compose = {
      enable = lib.mkOption {
        default = true;
        description = "Install a compose provider so `podman compose` / `podman-compose` works.";
        example = false;
        type = lib.types.bool;
      };

      provider = lib.mkOption {
        default = "podman-compose";
        description = ''
          Which compose provider to install.

          - "podman-compose": python-based tool (`podman-compose ...`)
          - "docker-compose": Docker Compose v2 binary (`podman compose ...` can use it as provider)
        '';
        example = "docker-compose";
        type = lib.types.enum [
          "podman-compose"
          "docker-compose"
        ];
      };
    };

    docker_compat = lib.mkOption {
      default = true;
      description = "Enable Docker compatibility shim so Docker CLI commands work with Podman.";
      example = false;
      type = lib.types.bool;
    };

    dns_enabled = lib.mkOption {
      default = true;
      description = "Enable DNS resolution for containers in the default Podman network.";
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_virtualization.enable (
    lib.mkMerge [
      (lib.mkIf eiros_podman.enable {
        virtualisation = {
          containers = {
            enable = true;
          };
          podman = {
            enable = true;
            dockerCompat = eiros_podman.docker_compat;
            defaultNetwork.settings.dns_enabled = eiros_podman.dns_enabled;
          };
        };
      })

      (lib.mkIf (eiros_podman.enable && eiros_podman.compose.enable) {
        environment.systemPackages = [ composePkg ];
      })
    ]
  );
}
