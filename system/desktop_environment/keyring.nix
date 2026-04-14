{ config, lib, ... }:
let
  eiros_keyring = config.eiros.system.desktop_environment.keyring;

  pam_service_options = builtins.listToAttrs (
    map (service_name: {
      name = service_name;
      value = {
        enableGnomeKeyring = true;
      };
    }) eiros_keyring.pam_services
  );
in
{
  options.eiros.system.desktop_environment.keyring = {
    enable = lib.mkOption {
      default = true;
      description = "Enable GNOME Keyring.";
      type = lib.types.bool;
    };

    pam_services = lib.mkOption {
      default = [
        "login"
      ];
      description = "PAM services to enable GNOME Keyring integration for.";
      type = lib.types.listOf lib.types.str;
    };

    seahorse.enable = lib.mkOption {
      default = true;
      description = "Enable Seahorse (GNOME Keyring GUI).";
      type = lib.types.bool;
    };

    ssh_agent.enable = lib.mkOption {
      default = false;
      description = "Enable the OpenSSH agent (programs.ssh.startAgent).";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_keyring.enable {
    programs = {
      seahorse = {
        enable = eiros_keyring.seahorse.enable;
      };

      ssh = {
        startAgent = eiros_keyring.ssh_agent.enable;
      };
    };

    security = {
      pam = {
        services = pam_service_options;
      };
    };

    services = {
      gnome = {
        gnome-keyring = {
          enable = true;
        };
      };
    };
  };
}
