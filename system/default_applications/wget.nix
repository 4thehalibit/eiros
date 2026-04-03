{ config, lib, pkgs, ... }:
let
  eiros_wget = config.eiros.system.default_applications.wget;
in
{
  options.eiros.system.default_applications.wget.enable = lib.mkOption {
    default = true;
    description = "Install wget for command-line file downloading.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_wget.enable {
    environment.systemPackages = [ pkgs.wget ];
  };
}
