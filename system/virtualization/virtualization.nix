# Master toggle for all virtualization modules; disabling this suppresses all sub-modules.
{ config, lib, ... }:
let
  eiros_virtualization = config.eiros.system.virtualization;
in
{
  options.eiros.system.virtualization = {
    enable = lib.mkOption {
      default = true;
      description = "Enable virtualization support.";
      example = false;
      type = lib.types.bool;
    };
  };

  config.warnings = lib.optionals (!eiros_virtualization.enable) [
    "Virtualization is disabled; all virtualization-related modules should be inactive."
  ];
}
