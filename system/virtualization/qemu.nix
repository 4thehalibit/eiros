# Installs QEMU for running virtual machines directly without libvirt.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_virtualization = config.eiros.system.virtualization;
  eiros_qemu = eiros_virtualization.qemu;
in
{
  options.eiros.system.virtualization.qemu = {
    enable = lib.mkOption {
      default = true;
      description = "Enable QEMU virtual machines.";
      example = false;
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.qemu;
      description = "QEMU package to install.";
      example = lib.literalExpression "pkgs.qemu_kvm";
      type = lib.types.package;
    };
  };

  config.environment.systemPackages = lib.mkIf (eiros_virtualization.enable && eiros_qemu.enable) [
    eiros_qemu.package
  ];
}
