# Configures declarative Neovim via nixvim with LSP, treesitter, telescope, and completion.
{ config, lib, pkgs, ... }:
let
  eiros_neovim = config.eiros.system.default_applications.editors.neovim;
  eiros_nixvim = config.eiros.system.default_applications.editors.nixvim;
in
{
  options.eiros.system.default_applications.editors.nixvim = {
    enable = lib.mkOption {
      default = true;
      description = "Enable nixvim for declarative Neovim configuration. Override repos configure plugins, LSP, and settings via programs.nixvim.*.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nixvim.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    extra_plugins = lib.mkOption {
      default = [ ];
      description = "Additional Vim plugin packages not available in nixvim's structured plugin options (programs.nixvim.plugins.*). Maps to programs.nixvim.extraPlugins.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nixvim.extra_plugins = [ pkgs.vimPlugins.vim-surround ];
        }
      '';
      type = lib.types.listOf lib.types.package;
    };

    extra_config_lua = lib.mkOption {
      default = "";
      description = "Raw Lua appended to the main body of the generated init.lua. Maps to programs.nixvim.extraConfigLua.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nixvim.extra_config_lua = "vim.opt.wrap = true";
        }
      '';
      type = lib.types.lines;
    };

    extra_config_lua_pre = lib.mkOption {
      default = "";
      description = "Raw Lua inserted before all nixvim-generated configuration. Maps to programs.nixvim.extraConfigLuaPre.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nixvim.extra_config_lua_pre = "vim.g.mapleader = \" \"";
        }
      '';
      type = lib.types.lines;
    };

    extra_config_lua_post = lib.mkOption {
      default = "";
      description = "Raw Lua inserted after all nixvim-generated configuration. Maps to programs.nixvim.extraConfigLuaPost.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nixvim.extra_config_lua_post = "require('custom').setup()";
        }
      '';
      type = lib.types.lines;
    };

    use_global_packages = lib.mkOption {
      default = true;
      description = "Use the host system nixpkgs instead of evaluating a second nixpkgs instance. Maps to programs.nixvim.nixpkgs.useGlobalPackages.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nixvim.use_global_packages = false;
        }
      '';
      type = lib.types.bool;
    };

    opts = {
      number = lib.mkOption {
        default = true;
        description = "Show absolute line numbers.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.number = false;
          }
        '';
        type = lib.types.bool;
      };

      relative_number = lib.mkOption {
        default = true;
        description = "Show relative line numbers.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.relative_number = false;
          }
        '';
        type = lib.types.bool;
      };

      clipboard = lib.mkOption {
        default = [ "unnamedplus" ];
        description = "Clipboard registers to use (maps to vim 'clipboard' option).";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.clipboard = [
              "unnamed"
              "unnamedplus"
            ];
          }
        '';
        type = lib.types.listOf lib.types.str;
      };

      undo_file = lib.mkOption {
        default = true;
        description = "Persist undo history across sessions.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.undo_file = false;
          }
        '';
        type = lib.types.bool;
      };

      auto_write_all = lib.mkOption {
        default = true;
        description = "Automatically write all buffers when leaving them.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.auto_write_all = false;
          }
        '';
        type = lib.types.bool;
      };

      tab_stop = lib.mkOption {
        default = 2;
        description = "Number of spaces a tab counts for.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.tab_stop = 4;
          }
        '';
        type = lib.types.int;
      };

      shift_width = lib.mkOption {
        default = 2;
        description = "Number of spaces used for each indentation step.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.shift_width = 4;
          }
        '';
        type = lib.types.int;
      };

      expand_tab = lib.mkOption {
        default = true;
        description = "Insert spaces instead of tab characters.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.expand_tab = false;
          }
        '';
        type = lib.types.bool;
      };

      split_right = lib.mkOption {
        default = true;
        description = "Open vertical splits to the right.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.split_right = false;
          }
        '';
        type = lib.types.bool;
      };

      split_below = lib.mkOption {
        default = true;
        description = "Open horizontal splits below.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.split_below = false;
          }
        '';
        type = lib.types.bool;
      };

      cursor_line = lib.mkOption {
        default = true;
        description = "Highlight the line containing the cursor.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.opts.cursor_line = false;
          }
        '';
        type = lib.types.bool;
      };
    };

    plugins = {
      lualine.enable = lib.mkOption {
        default = true;
        description = "Enable lualine status bar.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.lualine.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      bufferline.enable = lib.mkOption {
        default = true;
        description = "Enable bufferline tab bar.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.bufferline.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      which_key.enable = lib.mkOption {
        default = true;
        description = "Enable which-key keybind hints.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.which_key.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      indent_blankline.enable = lib.mkOption {
        default = true;
        description = "Enable indent-blankline indentation guides.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.indent_blankline.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      telescope.enable = lib.mkOption {
        default = true;
        description = "Enable telescope fuzzy finder.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.telescope.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      neo_tree.enable = lib.mkOption {
        default = true;
        description = "Enable neo-tree file explorer.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.neo_tree.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      gitsigns.enable = lib.mkOption {
        default = true;
        description = "Enable gitsigns git decorations.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.gitsigns.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      comment.enable = lib.mkOption {
        default = true;
        description = "Enable comment.nvim for easy commenting.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.comment.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      nvim_autopairs.enable = lib.mkOption {
        default = true;
        description = "Enable nvim-autopairs automatic bracket pairing.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.nvim_autopairs.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      treesitter = {
        enable = lib.mkOption {
          default = true;
          description = "Enable treesitter syntax highlighting and parsing.";
          example = lib.literalExpression ''
            {
              eiros.system.default_applications.editors.nixvim.plugins.treesitter.enable = false;
            }
          '';
          type = lib.types.bool;
        };

        grammar_packages = lib.mkOption {
          default = with pkgs.vimPlugins.nvim-treesitter-parsers; [
            nix
            lua
            bash
            json
            yaml
            toml
            markdown
            markdown_inline
          ];
          description = "Treesitter grammar packages to install.";
          example = lib.literalExpression ''
            {
              eiros.system.default_applications.editors.nixvim.plugins.treesitter.grammar_packages = with pkgs.vimPlugins.nvim-treesitter-parsers; [ python rust ];
            }
          '';
          type = lib.types.listOf lib.types.package;
        };
      };

      lspconfig.enable = lib.mkOption {
        default = true;
        description = "Enable nvim-lspconfig LSP client.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.lspconfig.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      cmp = {
        enable = lib.mkOption {
          default = true;
          description = "Enable nvim-cmp completion engine.";
          example = lib.literalExpression ''
            {
              eiros.system.default_applications.editors.nixvim.plugins.cmp.enable = false;
            }
          '';
          type = lib.types.bool;
        };

        auto_enable_sources = lib.mkOption {
          default = true;
          description = "Automatically enable completion sources.";
          example = lib.literalExpression ''
            {
              eiros.system.default_applications.editors.nixvim.plugins.cmp.auto_enable_sources = false;
            }
          '';
          type = lib.types.bool;
        };

        sources = lib.mkOption {
          default = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          description = "Completion sources for nvim-cmp.";
          example = lib.literalExpression ''
            {
              eiros.system.default_applications.editors.nixvim.plugins.cmp.sources = [ { name = "nvim_lsp"; } { name = "luasnip"; } ];
            }
          '';
          type = lib.types.listOf (lib.types.attrsOf lib.types.str);
        };
      };

      luasnip.enable = lib.mkOption {
        default = true;
        description = "Enable LuaSnip snippet engine.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nixvim.plugins.luasnip.enable = false;
          }
        '';
        type = lib.types.bool;
      };
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

      opts = {
        number = eiros_nixvim.opts.number;
        relativenumber = eiros_nixvim.opts.relative_number;
        clipboard = eiros_nixvim.opts.clipboard;
        undofile = eiros_nixvim.opts.undo_file;
        autowriteall = eiros_nixvim.opts.auto_write_all;
        tabstop = eiros_nixvim.opts.tab_stop;
        shiftwidth = eiros_nixvim.opts.shift_width;
        expandtab = eiros_nixvim.opts.expand_tab;
        splitright = eiros_nixvim.opts.split_right;
        splitbelow = eiros_nixvim.opts.split_below;
        cursorline = eiros_nixvim.opts.cursor_line;
      };

      plugins = {
        web-devicons.enable = true;

        lualine.enable = eiros_nixvim.plugins.lualine.enable;

        bufferline.enable = eiros_nixvim.plugins.bufferline.enable;

        which-key.enable = eiros_nixvim.plugins.which_key.enable;

        indent-blankline.enable = eiros_nixvim.plugins.indent_blankline.enable;

        telescope.enable = eiros_nixvim.plugins.telescope.enable;

        neo-tree.enable = eiros_nixvim.plugins.neo_tree.enable;

        gitsigns.enable = eiros_nixvim.plugins.gitsigns.enable;

        comment.enable = eiros_nixvim.plugins.comment.enable;

        nvim-autopairs.enable = eiros_nixvim.plugins.nvim_autopairs.enable;

        treesitter = {
          enable = eiros_nixvim.plugins.treesitter.enable;
          grammarPackages = eiros_nixvim.plugins.treesitter.grammar_packages;
        };

        lspconfig.enable = eiros_nixvim.plugins.lspconfig.enable;

        cmp = {
          enable = eiros_nixvim.plugins.cmp.enable;
          autoEnableSources = eiros_nixvim.plugins.cmp.auto_enable_sources;
          settings.sources = eiros_nixvim.plugins.cmp.sources;
        };

        luasnip.enable = eiros_nixvim.plugins.luasnip.enable;
      };

      extraPlugins = eiros_nixvim.extra_plugins;
      extraConfigLuaPre = eiros_nixvim.extra_config_lua_pre;
      extraConfigLua = eiros_nixvim.extra_config_lua;
      extraConfigLuaPost = eiros_nixvim.extra_config_lua_post;
    };
  };
}
