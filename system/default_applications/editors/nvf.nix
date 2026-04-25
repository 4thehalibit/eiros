# Configures declarative Neovim via nvf with LSP, treesitter, telescope, and completion.
{ config, lib, pkgs, ... }:
let
  eiros_neovim = config.eiros.system.default_applications.editors.neovim;
  eiros_nvf = config.eiros.system.default_applications.editors.nvf;
in
{
  options.eiros.system.default_applications.editors.nvf = {
    enable = lib.mkOption {
      default = true;
      description = "Enable nvf for declarative Neovim configuration. Override repos configure plugins, LSP, and settings via programs.nvf.settings.vim.*.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nvf.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    extra_plugins = lib.mkOption {
      default = { };
      description = "Additional Vim plugins not available in nvf's structured plugin options. Each entry is an attrset with package, optional setup string, and optional after list. Maps to programs.nvf.settings.vim.extraPlugins.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nvf.extra_plugins = {
            vim-surround = {
              package = pkgs.vimPlugins.vim-surround;
              setup = "";
              after = [];
            };
          };
        }
      '';
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          package = lib.mkOption {
            type = lib.types.package;
            description = "The vim plugin package.";
          };
          setup = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Lua string to execute after loading the plugin.";
          };
          after = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
            description = "Plugin names this plugin must load after.";
          };
        };
      });
    };

    extra_config_lua = lib.mkOption {
      default = "";
      description = "Raw Lua appended to the main body of the generated init.lua. Maps to programs.nvf.settings.vim.luaConfigRC.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nvf.extra_config_lua = "vim.opt.wrap = true";
        }
      '';
      type = lib.types.lines;
    };

    extra_config_lua_pre = lib.mkOption {
      default = "";
      description = "Raw Lua inserted before all nvf-generated configuration. Maps to programs.nvf.settings.vim.luaConfigPre.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nvf.extra_config_lua_pre = "vim.g.mapleader = \" \"";
        }
      '';
      type = lib.types.lines;
    };

    extra_config_lua_post = lib.mkOption {
      default = "";
      description = "Raw Lua inserted after all nvf-generated configuration. Maps to programs.nvf.settings.vim.luaConfigPost.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nvf.extra_config_lua_post = "require('custom').setup()";
        }
      '';
      type = lib.types.lines;
    };

    opts = {
      number = lib.mkOption {
        default = true;
        description = "Show absolute line numbers.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.number = false;
          }
        '';
        type = lib.types.bool;
      };

      relative_number = lib.mkOption {
        default = true;
        description = "Show relative line numbers.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.relative_number = false;
          }
        '';
        type = lib.types.bool;
      };

      clipboard = lib.mkOption {
        default = "unnamedplus";
        description = "Clipboard register to use (maps to vim 'clipboard' option).";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.clipboard = "unnamed,unnamedplus";
          }
        '';
        type = lib.types.str;
      };

      undo_file = lib.mkOption {
        default = true;
        description = "Persist undo history across sessions.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.undo_file = false;
          }
        '';
        type = lib.types.bool;
      };

      auto_write_all = lib.mkOption {
        default = true;
        description = "Automatically write all buffers when leaving them.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.auto_write_all = false;
          }
        '';
        type = lib.types.bool;
      };

      tab_stop = lib.mkOption {
        default = 2;
        description = "Number of spaces a tab counts for.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.tab_stop = 4;
          }
        '';
        type = lib.types.int;
      };

      shift_width = lib.mkOption {
        default = 2;
        description = "Number of spaces used for each indentation step.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.shift_width = 4;
          }
        '';
        type = lib.types.int;
      };

      expand_tab = lib.mkOption {
        default = true;
        description = "Insert spaces instead of tab characters.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.expand_tab = false;
          }
        '';
        type = lib.types.bool;
      };

      split_right = lib.mkOption {
        default = true;
        description = "Open vertical splits to the right.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.split_right = false;
          }
        '';
        type = lib.types.bool;
      };

      split_below = lib.mkOption {
        default = true;
        description = "Open horizontal splits below.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.split_below = false;
          }
        '';
        type = lib.types.bool;
      };

      cursor_line = lib.mkOption {
        default = true;
        description = "Highlight the line containing the cursor.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.opts.cursor_line = false;
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
            eiros.system.default_applications.editors.nvf.plugins.lualine.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      bufferline.enable = lib.mkOption {
        default = true;
        description = "Enable bufferline tab bar.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.bufferline.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      which_key.enable = lib.mkOption {
        default = true;
        description = "Enable which-key keybind hints.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.which_key.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      indent_blankline.enable = lib.mkOption {
        default = true;
        description = "Enable indent-blankline indentation guides.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.indent_blankline.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      telescope.enable = lib.mkOption {
        default = true;
        description = "Enable telescope fuzzy finder.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.telescope.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      neo_tree.enable = lib.mkOption {
        default = true;
        description = "Enable neo-tree file explorer.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.neo_tree.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      gitsigns.enable = lib.mkOption {
        default = true;
        description = "Enable gitsigns git decorations.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.gitsigns.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      comment.enable = lib.mkOption {
        default = true;
        description = "Enable comment.nvim for easy commenting.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.comment.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      nvim_autopairs.enable = lib.mkOption {
        default = true;
        description = "Enable nvim-autopairs automatic bracket pairing.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.nvim_autopairs.enable = false;
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
              eiros.system.default_applications.editors.nvf.plugins.treesitter.enable = false;
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
              eiros.system.default_applications.editors.nvf.plugins.treesitter.grammar_packages = with pkgs.vimPlugins.nvim-treesitter-parsers; [ python rust ];
            }
          '';
          type = lib.types.listOf lib.types.package;
        };
      };

      lspconfig.enable = lib.mkOption {
        default = true;
        description = "Enable LSP client support.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.lspconfig.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      cmp.enable = lib.mkOption {
        default = true;
        description = "Enable nvim-cmp completion engine.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.cmp.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      luasnip.enable = lib.mkOption {
        default = true;
        description = "Enable LuaSnip snippet engine.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.editors.nvf.plugins.luasnip.enable = false;
          }
        '';
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf (eiros_neovim.enable && eiros_nvf.enable) {
    programs.neovim.enable = lib.mkForce false;

    programs.nvf = {
      enable = true;
      defaultEditor = eiros_neovim.default_editor;
      settings = {
        vim = {
          viAlias = eiros_neovim.vi_alias.enable;
          vimAlias = eiros_neovim.vim_alias.enable;

          options = {
            number = eiros_nvf.opts.number;
            relativenumber = eiros_nvf.opts.relative_number;
            clipboard = eiros_nvf.opts.clipboard;
            undofile = eiros_nvf.opts.undo_file;
            autowriteall = eiros_nvf.opts.auto_write_all;
            tabstop = eiros_nvf.opts.tab_stop;
            shiftwidth = eiros_nvf.opts.shift_width;
            expandtab = eiros_nvf.opts.expand_tab;
            splitright = eiros_nvf.opts.split_right;
            splitbelow = eiros_nvf.opts.split_below;
            cursorline = eiros_nvf.opts.cursor_line;
          };

          statusline.lualine.enable = eiros_nvf.plugins.lualine.enable;

          tabline.nvimBufferline.enable = eiros_nvf.plugins.bufferline.enable;

          binds.whichKey.enable = eiros_nvf.plugins.which_key.enable;

          visuals.indentBlankline.enable = eiros_nvf.plugins.indent_blankline.enable;

          telescope.enable = eiros_nvf.plugins.telescope.enable;

          filetree.neo-tree.enable = eiros_nvf.plugins.neo_tree.enable;

          git.gitsigns.enable = eiros_nvf.plugins.gitsigns.enable;

          comments.comment-nvim.enable = eiros_nvf.plugins.comment.enable;

          autopairs.nvim-autopairs.enable = eiros_nvf.plugins.nvim_autopairs.enable;

          treesitter = {
            enable = eiros_nvf.plugins.treesitter.enable;
            grammars = eiros_nvf.plugins.treesitter.grammar_packages;
          };

          lsp.enable = eiros_nvf.plugins.lspconfig.enable;

          autocomplete.nvim-cmp.enable = eiros_nvf.plugins.cmp.enable;

          snippets.luasnip.enable = eiros_nvf.plugins.luasnip.enable;

          extraPlugins = eiros_nvf.extra_plugins;

          luaConfigPre = eiros_nvf.extra_config_lua_pre;
          luaConfigRC = eiros_nvf.extra_config_lua;
          luaConfigPost = eiros_nvf.extra_config_lua_post;
        };
      };
    };
  };
}
