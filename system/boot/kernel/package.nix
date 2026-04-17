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
  options.eiros.system.boot.kernel.package = lib.mkOption {
    default = pkgs.linuxPackages_latest;
    description = "The kernel package set to use for Eiros (e.g. pkgs.linuxPackages_latest).";
    example = lib.literalExpression ''
      {
        eiros.system.boot.kernel.package = pkgs.linuxPackages;
      }
    '';
    type = lib.types.attrs;
  };

  config = {
    assertions = [
      {
        assertion =
          (eiros_kernel.package ? kernel) && (lib.isDerivation eiros_kernel.package.kernel);
        message = "eiros.system.boot.kernel.package must be a linuxPackages set (an attrset containing a derivation at .kernel), e.g. pkgs.linuxPackages_latest.";
      }
    ];

    boot.kernelPackages = eiros_kernel.package;
  };
}
