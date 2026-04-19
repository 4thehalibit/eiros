# Installs fd, a fast and user-friendly find replacement.
{ config, lib, pkgs, ... }:
let
  eiros_fd = config.eiros.system.default_applications.file_management.fd;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.file_management.fd = {
    enable = lib.mkOption {
      default = true;
      description = "Install fd, a fast and user-friendly find replacement.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.fd.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    override.enable = lib.mkOption {
      default = true;
      description = "Alias find to fd so fd is used transparently in place of find.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.fd.override.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_fd.enable {
    environment.systemPackages = [ pkgs.fd ];

    programs.zsh.shellAliases = lib.mkIf (eiros_zsh.enable && eiros_fd.override.enable) {
      find = "fd";
    };
  };
}
