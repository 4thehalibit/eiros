{ config, lib, pkgs, ... }:
let
  eiros_usbutils = config.eiros.system.default_applications.usbutils;
in
{
  options.eiros.system.default_applications.usbutils.enable = lib.mkOption {
    default = true;
    description = "Install usbutils (lsusb) for USB device inspection.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_usbutils.enable {
    environment.systemPackages = [ pkgs.usbutils ];
  };
}
