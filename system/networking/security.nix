# Applies network security sysctl settings. Kept separate from performance.nix,
# which handles BBR congestion control and buffer tuning.
{ config, lib, ... }:
let
  eiros_net_sec = config.eiros.system.networking.security;
in
{
  options.eiros.system.networking.security = {
    enable = lib.mkOption {
      default = true;
      description = "Enable network security sysctl hardening.";
      example = lib.literalExpression ''
        {
          eiros.system.networking.security.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    block_icmp_redirects = lib.mkOption {
      default = true;
      description = ''
        Refuse ICMP/ICMPv6 redirect messages and stop sending them.
        Redirects allow a router to tell the host to use a different next-hop, but on a
        desktop they are unnecessary and can be forged by an on-path attacker to silently
        reroute traffic (MITM). No user-visible impact in typical home/office networks.
        Disable only if this machine is used as a software router between subnets.
      '';
      example = lib.literalExpression ''
        {
          eiros.system.networking.security.block_icmp_redirects = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_net_sec.enable {
    boot.kernel.sysctl = lib.mkIf eiros_net_sec.block_icmp_redirects {
      "net.ipv4.conf.all.accept_redirects"     = 0; # refuse IPv4 ICMP redirects on all interfaces
      "net.ipv4.conf.default.accept_redirects" = 0; # refuse IPv4 ICMP redirects on new interfaces
      "net.ipv6.conf.all.accept_redirects"     = 0; # refuse IPv6 ICMPv6 redirects on all interfaces
      "net.ipv6.conf.default.accept_redirects" = 0; # refuse IPv6 ICMPv6 redirects on new interfaces
      "net.ipv4.conf.all.send_redirects"       = 0; # do not send ICMP redirects; desktop is never a router
    };
  };
}
