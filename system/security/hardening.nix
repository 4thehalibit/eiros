# Applies security-focused sysctl hardening for filesystem and kernel information
# protection. Distinct from boot/kernel/tuning.nix, which handles performance tuning.
{ config, lib, ... }:
let
  eiros_hardening = config.eiros.system.security.hardening;
in
{
  options.eiros.system.security.hardening = {
    enable = lib.mkOption {
      default = true;
      description = "Enable security-focused kernel and filesystem hardening.";
      example = lib.literalExpression ''
        {
          eiros.system.security.hardening.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    fs_hardening = lib.mkOption {
      default = true;
      description = ''
        Enable filesystem hardening sysctl settings.
        Blocks TOCTOU race attacks via /tmp symlinks, FIFOs, and hardlinks.
        Disables core dumps from setuid processes.
        No user-visible impact for normal desktop use.
      '';
      example = lib.literalExpression ''
        {
          eiros.system.security.hardening.fs_hardening = false;
        }
      '';
      type = lib.types.bool;
    };

    kernel_info_restrict = lib.mkOption {
      default = true;
      description = ''
        Hide kernel symbol addresses and dmesg output from unprivileged users.
        Kernel addresses help attackers defeat ASLR when crafting exploits.
        Side effect: non-root users cannot read dmesg — use sudo dmesg instead.
      '';
      example = lib.literalExpression ''
        {
          eiros.system.security.hardening.kernel_info_restrict = false;
        }
      '';
      type = lib.types.bool;
    };

    bpf_hardening = lib.mkOption {
      default = true;
      description = ''
        Harden the eBPF JIT compiler to block JIT spray attacks.
        Adds slight overhead to eBPF-heavy workloads (bpftrace, advanced network
        filtering). Normal desktop use is unaffected.
      '';
      example = lib.literalExpression ''
        {
          eiros.system.security.hardening.bpf_hardening = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_hardening.enable {
    boot.kernel.sysctl = lib.mkMerge [
      (lib.mkIf eiros_hardening.fs_hardening {
        "fs.protected_fifos"     = 2; # block O_CREAT on FIFOs in sticky world-writable dirs; stops TOCTOU via /tmp
        "fs.protected_regular"   = 2; # same protection for regular files in sticky dirs
        "fs.protected_symlinks"  = 1; # prevent following symlinks in sticky dirs unless follower owns them
        "fs.protected_hardlinks" = 1; # prevent hardlinks to files you don't own; blocks hardlink privilege escalation
        "fs.suid_dumpable"       = 0; # disable core dumps from setuid/setgid processes; prevents memory disclosure
      })

      (lib.mkIf eiros_hardening.kernel_info_restrict {
        "kernel.kptr_restrict"  = 1; # hide kernel symbol addresses from non-root; defeats ASLR-bypass via /proc/kallsyms
        "kernel.dmesg_restrict" = 1; # restrict dmesg to root; kernel log contains addresses useful for exploit dev
      })

      (lib.mkIf eiros_hardening.bpf_hardening {
        "net.core.bpf_jit_harden" = 2; # blind JIT constants and disable JIT spray; small overhead on eBPF-heavy workloads
      })
    ];
  };
}
