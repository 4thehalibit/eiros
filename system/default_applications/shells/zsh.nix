# Configures Zsh as the default shell with Oh My Zsh, autosuggestions, syntax highlighting, and aliases.
{ config, lib, pkgs, ... }:
let
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
  eiros_eza = config.eiros.system.default_applications.file_management.eza;
  eiros_bat = config.eiros.system.default_applications.file_management.bat;
in
{
  options.eiros.system.default_applications.shells.zsh = {
    enable = lib.mkOption {
      default = true;
      description = "Enable zsh system-wide.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.zsh.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    default_shell.enable = lib.mkOption {
      default = true;
      description = "Set zsh as the default shell for all users (users.defaultUserShell).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.zsh.default_shell.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    autosuggestions.enable = lib.mkOption {
      default = true;
      description = "Enable zsh-autosuggestions (suggests commands from history as you type).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.zsh.autosuggestions.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    syntax_highlighting.enable = lib.mkOption {
      default = true;
      description = "Enable zsh-syntax-highlighting (highlights commands as you type).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.zsh.syntax_highlighting.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    oh_my_zsh = {
      enable = lib.mkOption {
        default = true;
        description = "Enable Oh My Zsh framework.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.shells.zsh.oh_my_zsh.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      theme = lib.mkOption {
        default = "spaceship";
        description = "Oh My Zsh theme to use.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.shells.zsh.oh_my_zsh.theme = "robbyrussell";
          }
        '';
        type = lib.types.str;
      };

      custom_packages = lib.mkOption {
        default = [ pkgs.spaceship-prompt ];
        description = "Additional packages providing Oh My Zsh themes or plugins.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.shells.zsh.oh_my_zsh.custom_packages = [ pkgs.spaceship-prompt ];
          }
        '';
        type = lib.types.listOf lib.types.package;
      };

      plugins = lib.mkOption {
        default = [
          "colored-man-pages"
          "copypath"
          "direnv"
          "extract"
          "git"
          "history"
          "sudo"
        ];
        description = "Oh My Zsh plugins to enable.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.shells.zsh.oh_my_zsh.plugins = [
              "git"
              "sudo"
              "extract"
            ];
          }
        '';
        type = lib.types.listOf lib.types.str;
      };
    };

    hist_size = lib.mkOption {
      default = 50000;
      description = "Maximum number of history entries to keep.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.zsh.hist_size = 100000;
        }
      '';
      type = lib.types.int;
    };

    set_options = lib.mkOption {
      default = [ "HIST_IGNORE_DUPS" "HIST_IGNORE_SPACE" "SHARE_HISTORY" ];
      description = "Zsh options to enable (setopt).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.zsh.set_options = [
            "HIST_IGNORE_DUPS"
            "SHARE_HISTORY"
          ];
        }
      '';
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf eiros_zsh.enable {
    users.defaultUserShell = lib.mkIf eiros_zsh.default_shell.enable pkgs.zsh;

    programs.zsh = {
      enable = true;

      autosuggestions.enable = eiros_zsh.autosuggestions.enable;
      syntaxHighlighting.enable = eiros_zsh.syntax_highlighting.enable;

      histSize = eiros_zsh.hist_size;
      setOptions = eiros_zsh.set_options;

      shellAliases = lib.mkMerge [
        (lib.mkIf eiros_eza.enable {
          ls   = "eza --icons";
          ll   = "eza -lh --icons --git";
          la   = "eza -lah --icons --git";
          tree = "eza --tree --icons";
        })
        (lib.mkIf eiros_bat.enable {
          cat = "bat";
        })
      ];

      ohMyZsh = lib.mkIf eiros_zsh.oh_my_zsh.enable {
        enable = true;
        theme = eiros_zsh.oh_my_zsh.theme;
        plugins = eiros_zsh.oh_my_zsh.plugins;
        customPkgs = eiros_zsh.oh_my_zsh.custom_packages;
      };
    };
  };
}
