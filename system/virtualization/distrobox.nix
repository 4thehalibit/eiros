{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_virtualization = config.eiros.system.virtualization;
in
{
  options.eiros.system.virtualization.distrobox.enable = lib.mkOption {
    default = true;
    description = "Enable distrobox.";
    type = lib.types.bool;
  };
  config = lib.mkIf (eiros_virtualization.enable && eiros_virtualization.distrobox.enable) {
    environment.systemPackages = [ pkgs.distrobox ];
  };
}
