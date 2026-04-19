# Installs usbutils (lsusb) for USB device inspection.
{ config, lib, pkgs, ... }:
let
  eiros_usbutils = config.eiros.system.default_applications.system_monitoring.usbutils;
in
{
  options.eiros.system.default_applications.system_monitoring.usbutils.enable = lib.mkOption {
    default = true;
    description = "Install usbutils (lsusb) for USB device inspection.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.system_monitoring.usbutils.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_usbutils.enable {
    environment.systemPackages = [ pkgs.usbutils ];
  };
}
