# Installs eza, a modern ls replacement with colour, icons, and git status.
{ config, lib, pkgs, ... }:
let
  eiros_eza = config.eiros.system.default_applications.file_management.eza;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.file_management.eza = {
    enable = lib.mkOption {
      default = true;
      description = "Install eza, a modern ls replacement with colour, icons, and git status.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.eza.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    override.enable = lib.mkOption {
      default = true;
      description = "Alias ls, ll, la, and tree to eza variants so eza is used transparently in place of ls.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.eza.override.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_eza.enable {
    environment.systemPackages = [ pkgs.eza ];

    programs.zsh.shellAliases = lib.mkIf (eiros_zsh.enable && eiros_eza.override.enable) {
      ls   = "eza --icons";
      ll   = "eza -lh --icons --git";
      la   = "eza -lah --icons --git";
      tree = "eza --tree --icons";
    };
  };
}
