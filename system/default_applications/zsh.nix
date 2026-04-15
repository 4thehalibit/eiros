{ config, lib, pkgs, ... }:
let
  eiros_zsh = config.eiros.system.default_applications.zsh;
  eiros_eza = config.eiros.system.default_applications.eza;
  eiros_bat = config.eiros.system.default_applications.bat;
in
{
  options.eiros.system.default_applications.zsh = {
    enable = lib.mkOption {
      default = true;
      description = "Enable zsh system-wide.";
      type = lib.types.bool;
    };

    default_shell.enable = lib.mkOption {
      default = true;
      description = "Set zsh as the default shell for all users (users.defaultUserShell).";
      type = lib.types.bool;
    };

    autosuggestions.enable = lib.mkOption {
      default = true;
      description = "Enable zsh-autosuggestions (suggests commands from history as you type).";
      type = lib.types.bool;
    };

    syntax_highlighting.enable = lib.mkOption {
      default = true;
      description = "Enable zsh-syntax-highlighting (highlights commands as you type).";
      type = lib.types.bool;
    };

    oh_my_zsh = {
      enable = lib.mkOption {
        default = true;
        description = "Enable Oh My Zsh framework.";
        type = lib.types.bool;
      };

      theme = lib.mkOption {
        default = "spaceship";
        description = "Oh My Zsh theme to use.";
        type = lib.types.str;
      };

      custom_packages = lib.mkOption {
        default = [ pkgs.spaceship-prompt ];
        description = "Additional packages providing Oh My Zsh themes or plugins.";
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
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config = lib.mkIf eiros_zsh.enable {
    users.defaultUserShell = lib.mkIf eiros_zsh.default_shell.enable pkgs.zsh;

    programs.zsh = {
      enable = true;

      autosuggestions.enable = eiros_zsh.autosuggestions.enable;
      syntaxHighlighting.enable = eiros_zsh.syntax_highlighting.enable;

      histSize = 50000;
      setOptions = [ "HIST_IGNORE_DUPS" "HIST_IGNORE_SPACE" "SHARE_HISTORY" ];

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
