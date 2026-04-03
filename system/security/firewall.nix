{ config, lib, ... }:
let
  eiros_firewall = config.eiros.system.security.firewall;
in
{
  options.eiros.system.security.firewall = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the NixOS firewall.";
      type = lib.types.bool;
    };

    log_refused = lib.mkOption {
      default = true;
      description = "Log refused incoming connections.";
      type = lib.types.bool;
    };

    allowed_tcp_ports = lib.mkOption {
      default = [ ];
      description = "TCP ports to allow through the firewall.";
      type = lib.types.listOf lib.types.port;
    };

    allowed_udp_ports = lib.mkOption {
      default = [ ];
      description = "UDP ports to allow through the firewall.";
      type = lib.types.listOf lib.types.port;
    };
  };

  config = lib.mkIf eiros_firewall.enable {
    networking.firewall = {
      enable = true;
      logRefusedConnections = eiros_firewall.log_refused;
      allowedTCPPorts = eiros_firewall.allowed_tcp_ports;
      allowedUDPPorts = eiros_firewall.allowed_udp_ports;
    };
  };
}
