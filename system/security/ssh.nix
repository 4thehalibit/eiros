# Configures the OpenSSH daemon with key-only authentication defaults.
{ config, lib, ... }:
let
  eiros_ssh = config.eiros.system.security.ssh;
in
{
  options.eiros.system.security.ssh = {
    enable = lib.mkOption {
      default = false;
      description = "Enable the OpenSSH daemon.";
      example = true;
      type = lib.types.bool;
    };

    password_authentication = lib.mkOption {
      default = false;
      description = "Allow password authentication over SSH. Disabled by default — use key-based auth.";
      example = true;
      type = lib.types.bool;
    };

    permit_root_login = lib.mkOption {
      default = "no";
      description = "Whether to allow root login over SSH (no, yes, prohibit-password).";
      example = "prohibit-password";
      type = lib.types.enum [ "no" "yes" "prohibit-password" ];
    };

    kbd_interactive_authentication = lib.mkOption {
      default = false;
      description = "Allow keyboard-interactive authentication over SSH. Disabled by default — use key-based or password auth instead.";
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (!eiros_ssh.enable) {
      services.openssh.enable = false;
    })

    (lib.mkIf eiros_ssh.enable {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = eiros_ssh.password_authentication;
          KbdInteractiveAuthentication = eiros_ssh.kbd_interactive_authentication;
          PermitRootLogin = eiros_ssh.permit_root_login;
        };
      };
    })
  ];
}
