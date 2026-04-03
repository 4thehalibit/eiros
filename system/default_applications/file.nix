{ config, lib, pkgs, ... }:
let
  eiros_file = config.eiros.system.default_applications.file;
in
{
  options.eiros.system.default_applications.file.enable = lib.mkOption {
    default = true;
    description = "Install file for determining file types.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_file.enable {
    environment.systemPackages = [ pkgs.file ];
  };
}
