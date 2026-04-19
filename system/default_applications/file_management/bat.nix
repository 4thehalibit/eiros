# Installs bat, a syntax-highlighting cat replacement with git integration.
{ config, lib, pkgs, ... }:
let
  eiros_bat = config.eiros.system.default_applications.file_management.bat;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.file_management.bat = {
    enable = lib.mkOption {
      default = true;
      description = "Install bat, a cat replacement with syntax highlighting and git integration.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.bat.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    override.enable = lib.mkOption {
      default = true;
      description = "Alias cat to bat so bat is used transparently in place of cat.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.bat.override.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_bat.enable {
    environment.systemPackages = [ pkgs.bat ];

    programs.zsh.shellAliases = lib.mkIf (eiros_zsh.enable && eiros_bat.override.enable) {
      cat = "bat";
    };
  };
}
