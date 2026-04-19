# Installs wl-clipboard (wl-copy/wl-paste) for Wayland clipboard access from the terminal.
{ config, lib, pkgs, ... }:
let
  eiros_wl_clipboard = config.eiros.system.default_applications.utilities.wl_clipboard;
in
{
  options.eiros.system.default_applications.utilities.wl_clipboard.enable = lib.mkOption {
    default = true;
    description = "Install wl-clipboard (wl-copy/wl-paste) for Wayland clipboard integration.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.utilities.wl_clipboard.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_wl_clipboard.enable {
    environment.systemPackages = [ pkgs.wl-clipboard ];
  };
}
