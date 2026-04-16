# Installs lazygit, a TUI git client.
{ config, lib, pkgs, ... }:
let
  eiros_lazygit = config.eiros.system.default_applications.lazygit;
  eiros_zsh = config.eiros.system.default_applications.zsh;
in
{
  options.eiros.system.default_applications.lazygit = {
    enable = lib.mkOption {
      default = true;
      description = "Install lazygit, a terminal UI for git.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.lazygit.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    alias.enable = lib.mkOption {
      default = true;
      description = "Add a lg shell alias for lazygit.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.lazygit.alias.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_lazygit.enable {
    environment.systemPackages = [ pkgs.lazygit ];

    programs.zsh.shellAliases = lib.mkIf (eiros_lazygit.alias.enable && eiros_zsh.enable) {
      lg = "lazygit";
    };
  };
}
