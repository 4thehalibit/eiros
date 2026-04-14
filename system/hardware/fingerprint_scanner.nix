{ config, lib, ... }:
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
    services.fprintd = {
      enable = true;
      global = false;
    };

    security.pam.services = builtins.listToAttrs (
      map (service_name: {
        name = service_name;
        value.fprintAuth = true;
      }) eiros_fingerprint.pam_services
    );
  };
}
