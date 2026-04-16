# Enables sops-nix for declarative secret management via SOPS + age/GPG.
{ config, lib, inputs, ... }:
let
  eiros_sops = config.eiros.system.security.sops;
in
{
  options.eiros.system.security.sops = {
    enable = lib.mkOption {
      default = false;
      description = "Enable sops-nix for declarative secret management (requires sops-nix flake input).";
      example = lib.literalExpression ''
        {
          eiros.system.security.sops.enable = true;
        }
      '';
      type = lib.types.bool;
    };

    default_sops_file = lib.mkOption {
      default = null;
      description = "Path to the default SOPS secrets file (e.g. /etc/nixos/secrets/secrets.yaml).";
      example = lib.literalExpression ''
        {
          eiros.system.security.sops.default_sops_file = ./secrets/secrets.yaml;
        }
      '';
      type = lib.types.nullOr lib.types.path;
    };

    age_key_file = lib.mkOption {
      default = "/var/lib/sops-nix/age-key.txt";
      description = "Path to the age private key file used to decrypt secrets.";
      example = lib.literalExpression ''
        {
          eiros.system.security.sops.age_key_file = "/root/.config/sops/age/keys.txt";
        }
      '';
      type = lib.types.str;
    };
  };

  config = lib.mkIf eiros_sops.enable {
    assertions = [
      {
        assertion = eiros_sops.default_sops_file != null;
        message = "eiros.system.security.sops.default_sops_file must be set when sops is enabled.";
      }
    ];

    sops = {
      defaultSopsFile = eiros_sops.default_sops_file;
      age.keyFile = eiros_sops.age_key_file;
    };
  };
}
