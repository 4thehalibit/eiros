# Configures Neovim as the default editor with vi/vim aliases.
{ config, lib, ... }:
let
  eiros_neovim = config.eiros.system.default_applications.neovim;
in
{
  options.eiros.system.default_applications.neovim = {
    default_editor = lib.mkOption {
      default = true;
      description = "Set NeoVim as the default editor ($EDITOR, $VISUAL).";
      example = false;
      type = lib.types.bool;
    };

    enable = lib.mkOption {
      default = true;
      description = "Whether or not to use NeoVim as the editor for Eiros.";
      example = false;
      type = lib.types.bool;
    };

    vi_alias.enable = lib.mkOption {
      default = true;
      description = "Provide the vi alias via NeoVim.";
      example = false;
      type = lib.types.bool;
    };

    vim_alias.enable = lib.mkOption {
      default = true;
      description = "Provide the vim alias via NeoVim.";
      example = false;
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
