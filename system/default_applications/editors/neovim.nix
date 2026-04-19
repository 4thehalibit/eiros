# Configures Neovim as the default editor with vi/vim aliases.
{ config, lib, ... }:
let
  eiros_neovim = config.eiros.system.default_applications.editors.neovim;
in
{
  options.eiros.system.default_applications.editors.neovim = {
    default_editor = lib.mkOption {
      default = true;
      description = "Set NeoVim as the default editor ($EDITOR, $VISUAL).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.neovim.default_editor = false;
        }
      '';
      type = lib.types.bool;
    };

    enable = lib.mkOption {
      default = true;
      description = "Whether or not to use NeoVim as the editor for Eiros.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.neovim.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    vi_alias.enable = lib.mkOption {
      default = true;
      description = "Provide the vi alias via NeoVim.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.neovim.vi_alias.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    vim_alias.enable = lib.mkOption {
      default = true;
      description = "Provide the vim alias via NeoVim.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.neovim.vim_alias.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config.programs.neovim = lib.mkIf eiros_neovim.enable {
    defaultEditor = eiros_neovim.default_editor;
    enable = true;
    viAlias = eiros_neovim.vi_alias.enable;
    vimAlias = eiros_neovim.vim_alias.enable;
  };
}
