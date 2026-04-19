# Installs fd, a fast and user-friendly find replacement.
{ config, lib, pkgs, ... }:
let
  eiros_fd = config.eiros.system.default_applications.file_management.fd;
in
{
  options.eiros.system.default_applications.file_management.fd.enable = lib.mkOption {
    default = true;
    description = "Install fd, a fast and user-friendly find replacement.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.file_management.fd.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_fd.enable {
    environment.systemPackages = [ pkgs.fd ];
  };
}
