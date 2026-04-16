# Selects the kernel package set (e.g. linuxPackages_latest) used for the system.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_kernel = config.eiros.system.boot.kernel;
in
{
  options.eiros.system.boot.kernel.kernel_package = lib.mkOption {
    default = pkgs.linuxPackages_latest;
    description = "The kernel package set to use for Eiros (e.g. pkgs.linuxPackages_latest).";
    example = lib.literalExpression "pkgs.linuxPackages";
    type = lib.types.attrs;
  };

  config = {
    assertions = [
      {
        assertion =
          (eiros_kernel.kernel_package ? kernel) && (lib.isDerivation eiros_kernel.kernel_package.kernel);
        message = "eiros.system.boot.kernel.kernel_package must be a linuxPackages set (an attrset containing a derivation at .kernel), e.g. pkgs.linuxPackages_latest.";
      }
    ];

    boot.kernelPackages = eiros_kernel.kernel_package;
  };
}
