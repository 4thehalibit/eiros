{ config, lib, ... }:
let
  eiros_ssh = config.eiros.system.security.ssh;
in
{
  options.eiros.system.security.ssh = {
    enable = lib.mkOption {
      default = false;
      description = "Enable the OpenSSH daemon.";
      type = lib.types.bool;
    };

    password_authentication = lib.mkOption {
      default = false;
      description = "Allow password authentication over SSH. Disabled by default — use key-based auth.";
      type = lib.types.bool;
    };

    permit_root_login = lib.mkOption {
      default = "no";
      description = "Whether to allow root login over SSH (no, yes, prohibit-password).";
      type = lib.types.enum [ "no" "yes" "prohibit-password" ];
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
          KbdInteractiveAuthentication = false;
          PermitRootLogin = eiros_ssh.permit_root_login;
        };
      };
    })
  ];
}
