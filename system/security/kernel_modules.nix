# Blacklists kernel modules that expose DMA attack surface or implement unused
# legacy network protocols. Each group can be disabled independently.
{ config, lib, ... }:
let
  eiros_km = config.eiros.system.security.kernel_modules;
in
{
  options.eiros.system.security.kernel_modules = {
    enable = lib.mkOption {
      default = true;
      description = "Enable kernel module blacklisting for attack surface reduction.";
      example = lib.literalExpression ''
        {
          eiros.system.security.kernel_modules.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    firewire = lib.mkOption {
      default = true;
      description = "Blacklist FireWire kernel modules. FireWire supports direct memory access (DMA) and can be exploited for physical memory attacks. Safe to disable if no FireWire devices are used.";
      example = lib.literalExpression ''
        {
          eiros.system.security.kernel_modules.firewire = false;
        }
      '';
      type = lib.types.bool;
    };

    legacy_protocols = lib.mkOption {
      default = true;
      description = "Blacklist unused legacy network protocol modules (dccp, sctp, rds, tipc). These protocols are rarely used on desktops and have had multiple kernel CVEs. Blacklisting prevents them from being loaded even by root.";
      example = lib.literalExpression ''
        {
          eiros.system.security.kernel_modules.legacy_protocols = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_km.enable {
    boot.blacklistedKernelModules =
      (lib.optionals eiros_km.firewire [
        "firewire_core"  # FireWire core — DMA attack surface
        "firewire_ohci"  # FireWire OHCI host controller
        "firewire_sbp2"  # FireWire SBP-2 (storage protocol over FireWire)
        "ohci1394"       # Legacy IEEE 1394 OHCI driver
        "sbp2"           # Legacy SBP-2 over IEEE 1394
      ])
      ++ (lib.optionals eiros_km.legacy_protocols [
        "dccp"   # Datagram Congestion Control Protocol — multiple historical CVEs
        "sctp"   # Stream Control Transmission Protocol — rarely used on desktops
        "rds"    # Reliable Datagram Sockets — rarely used, has had kernel CVEs
        "tipc"   # Transparent Inter-Process Communication — cluster protocol, not needed on desktops
      ]);
  };
}
