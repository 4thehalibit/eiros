{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_fingerprint = config.eiros.system.hardware.fingerprint_scanner;
in
{
  options.eiros.system.hardware.fingerprint_scanner = {
    enable = lib.mkOption {
      default = false;
      description = "Enable fingerprint scanner support via fprintd.";
      type = lib.types.bool;
    };
    pam_services = lib.mkOption {
      default = [
        "login"
        "sudo"
      ];
      description = ''
        PAM services to enable fingerprint authentication for.
        WARNING: "sudo" is included by default. This means a fingerprint
        can authorize privilege escalation without a password. Remove "sudo"
        from this list if that is undesirable in your environment.
      '';
      type = lib.types.listOf lib.types.str;
    };
  };
  config = lib.mkIf eiros_fingerprint.enable {
    services.fprintd.enable = true;
    security.pam.services =
      builtins.listToAttrs (
        map (service_name: {
          name = service_name;
          value.fprintAuth = true;
        }) eiros_fingerprint.pam_services
      )
      // {
        greetd.text = ''
          # Account management.
          account required ${pkgs.linux-pam}/lib/security/pam_unix.so

          # Authentication management.
          auth optional ${pkgs.linux-pam}/lib/security/pam_unix.so likeauth nullok
          auth optional ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
          auth sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so likeauth nullok try_first_pass
          auth required ${pkgs.linux-pam}/lib/security/pam_deny.so

          # Password management.
          password sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so nullok yescrypt
          password optional ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so use_authtok

          # Session management.
          session required ${pkgs.linux-pam}/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0
          session required ${pkgs.linux-pam}/lib/security/pam_unix.so
          session required ${pkgs.linux-pam}/lib/security/pam_loginuid.so
          session optional ${pkgs.systemd}/lib/security/pam_systemd.so
          session required ${pkgs.linux-pam}/lib/security/pam_limits.so conf=/nix/store/d7hsf3gq9mjfd8ncs9bcx6lbhy3r2ddc-limits.conf
          session optional ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
        '';
      };
  };
}
