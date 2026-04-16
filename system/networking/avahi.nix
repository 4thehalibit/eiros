# Enables Avahi for mDNS/Zeroconf — resolves .local hostnames and advertises LAN services.
{ config, lib, ... }:
let
  eiros_avahi = config.eiros.system.networking.avahi;
in
{
  options.eiros.system.networking.avahi = {
    enable = lib.mkOption {
      default = false;
      description = "Enable Avahi for mDNS/Zeroconf LAN service discovery and .local hostname resolution.";
      example = lib.literalExpression ''
        {
          eiros.system.networking.avahi.enable = true;
        }
      '';
      type = lib.types.bool;
    };

    nss_mdns.enable = lib.mkOption {
      default = true;
      description = "Enable NSS mDNS so that .local hostnames resolve via /etc/nsswitch.conf.";
      example = lib.literalExpression ''
        {
          eiros.system.networking.avahi.nss_mdns.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    publish = {
      enable = lib.mkOption {
        default = false;
        description = "Advertise this machine's services and addresses on the LAN.";
        example = lib.literalExpression ''
          {
            eiros.system.networking.avahi.publish.enable = true;
          }
        '';
        type = lib.types.bool;
      };

      addresses.enable = lib.mkOption {
        default = true;
        description = "Publish this machine's IP addresses via mDNS (requires publish.enable).";
        example = lib.literalExpression ''
          {
            eiros.system.networking.avahi.publish.addresses.enable = false;
          }
        '';
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf eiros_avahi.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = eiros_avahi.nss_mdns.enable;
      publish = {
        enable = eiros_avahi.publish.enable;
        addresses = eiros_avahi.publish.enable && eiros_avahi.publish.addresses.enable;
      };
    };
  };
}
