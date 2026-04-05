{ config, lib, pkgs, ... }:
let
  eiros_neovim = config.eiros.system.default_applications.neovim;
  eiros_nixvim = config.eiros.system.default_applications.nixvim;
in
{
  options.eiros.system.default_applications.nixvim = {
    enable = lib.mkOption {
      default = true;
      description = "Enable nixvim for declarative Neovim configuration. Override repos configure plugins, LSP, and settings via programs.nixvim.*.";
      type = lib.types.bool;
    };

    extra_plugins = lib.mkOption {
      default = [ ];
      description = "Additional Vim plugin packages not available in nixvim's structured plugin options (programs.nixvim.plugins.*). Maps to programs.nixvim.extraPlugins.";
      type = lib.types.listOf lib.types.package;
    };

    extra_config_lua = lib.mkOption {
      default = "";
      description = "Raw Lua appended to the main body of the generated init.lua. Maps to programs.nixvim.extraConfigLua.";
      type = lib.types.lines;
    };

    extra_config_lua_pre = lib.mkOption {
      default = "";
      description = "Raw Lua inserted before all nixvim-generated configuration. Maps to programs.nixvim.extraConfigLuaPre.";
      type = lib.types.lines;
    };

    extra_config_lua_post = lib.mkOption {
      default = "";
      description = "Raw Lua inserted after all nixvim-generated configuration. Maps to programs.nixvim.extraConfigLuaPost.";
      type = lib.types.lines;
    };

    use_global_packages = lib.mkOption {
      default = true;
      description = "Use the host system nixpkgs instead of evaluating a second nixpkgs instance. Maps to programs.nixvim.nixpkgs.useGlobalPackages.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (eiros_neovim.enable && eiros_nixvim.enable) {
    programs.neovim.enable = lib.mkForce false;

    programs.nixvim = {
      enable = true;
      defaultEditor = eiros_neovim.default_editor;
      viAlias = eiros_neovim.vi_alias.enable;
      vimAlias = eiros_neovim.vim_alias.enable;

      nixpkgs.useGlobalPackages = eiros_nixvim.use_global_packages;

      # --- Editor behavior ---
      opts = {
        number = true;
        relativenumber = true;
        clipboard = [ "unnamedplus" ];
        undofile = true;
        autowriteall = true;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        splitright = true;
        splitbelow = true;
        cursorline = true;
      };

      # --- UI plugins ---
      plugins = {
        web-devicons.enable = true;

        lualine.enable = true;

        bufferline.enable = true;

        which-key.enable = true;

        indent-blankline.enable = true;

        # --- Navigation / editing ---
        telescope.enable = true;

        neo-tree.enable = true;

        gitsigns.enable = true;

        comment.enable = true;

        nvim-autopairs.enable = true;

        # --- LSP / completion ---
        treesitter = {
          enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            nix
            lua
            bash
            json
            yaml
            toml
            markdown
            markdown_inline
          ];
        };

        lspconfig.enable = true;

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings.sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };

        luasnip.enable = true;
      };

      extraPlugins = eiros_nixvim.extra_plugins;
      extraConfigLuaPre = eiros_nixvim.extra_config_lua_pre;
      extraConfigLua = eiros_nixvim.extra_config_lua;
      extraConfigLuaPost = eiros_nixvim.extra_config_lua_post;
    };
  };
}
