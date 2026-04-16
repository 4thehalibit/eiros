# Installs fd, a fast and user-friendly find replacement.
{ config, lib, pkgs, ... }:
let
  eiros_fd = config.eiros.system.default_applications.fd;
in
{
  options.eiros.system.default_applications.fd.enable = lib.mkOption {
    default = true;
    description = "Install fd, a fast and user-friendly find replacement.";
    example = false;
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_fd.enable {
    environment.systemPackages = [ pkgs.fd ];
  };
}
