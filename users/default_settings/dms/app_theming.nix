# DMS application theming (GTK, Qt, portals, icon theme) and per-app
# matugen template toggle options.
{ lib, ... }:
{
  options.eiros.system.user_defaults.dms.app_theming = {

    # ── Application theming ────────────────────────────────────────────────
    gtk.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Apply the active DMS color scheme to GTK 3/4 applications via matugen.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.app_theming.gtk.enable = false;
        }
      '';
    };

    qt.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Apply the active DMS color scheme to Qt applications via qt5ct/qt6ct.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.app_theming.qt.enable = false;
        }
      '';
    };

    sync_mode_with_portal = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Sync dark/light mode with the XDG desktop portal (benefits Flatpak apps).";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.app_theming.sync_mode_with_portal = false;
        }
      '';
    };

    terminals_always_dark = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Always use the dark color variant for terminal applications even in light mode.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.app_theming.terminals_always_dark = false;
        }
      '';
    };

    icon_theme = lib.mkOption {
      default = "System Default";
      type = lib.types.str;
      description = "Icon theme name. \"System Default\" defers to the platform theme (QT_QPA_PLATFORMTHEME).";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.app_theming.icon_theme = "Papirus";
        }
      '';
    };

    network_preference = lib.mkOption {
      default = "auto";
      type = lib.types.str;
      description = "Preferred network display type. Options: auto, wifi, ethernet.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.app_theming.network_preference = "wifi";
        }
      '';
    };

    # ── Matugen template toggles ───────────────────────────────────────────
    matugen = {
      run_dms_templates = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Run all DMS-provided matugen templates on theme or wallpaper change.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.run_dms_templates = false;
          }
        '';
      };

      gtk = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate GTK theme colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.gtk = false;
          }
        '';
      };

      niri = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Niri compositor color config via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.niri = false;
          }
        '';
      };

      hyprland = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Hyprland compositor color config via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.hyprland = false;
          }
        '';
      };

      mangowc = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate MangoWC compositor color config via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.mangowc = false;
          }
        '';
      };

      qt5ct = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate qt5ct color palette via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.qt5ct = false;
          }
        '';
      };

      qt6ct = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate qt6ct color palette via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.qt6ct = false;
          }
        '';
      };

      firefox = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Firefox theme colors via matugen (requires MaterialFox or compatible theme).";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.firefox = false;
          }
        '';
      };

      pywalfox = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Pywalfox Firefox theme colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.pywalfox = false;
          }
        '';
      };

      zen_browser = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Zen Browser theme colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.zen_browser = true;
          }
        '';
      };

      vesktop = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Vesktop (Discord) theme colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.vesktop = false;
          }
        '';
      };

      equibop = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Equibop (Discord) theme colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.equibop = false;
          }
        '';
      };

      ghostty = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Ghostty terminal colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.ghostty = false;
          }
        '';
      };

      kitty = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Kitty terminal colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.kitty = false;
          }
        '';
      };

      foot = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Foot terminal colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.foot = false;
          }
        '';
      };

      alacritty = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Alacritty terminal colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.alacritty = false;
          }
        '';
      };

      neovim = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Generate Neovim color scheme via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.neovim = true;
          }
        '';
      };

      wezterm = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate WezTerm terminal colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.wezterm = false;
          }
        '';
      };

      dgop = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate dgop (GTK color override proxy) colors via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.dgop = false;
          }
        '';
      };

      kcolorscheme = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate KDE color scheme via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.kcolorscheme = false;
          }
        '';
      };

      vscode = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate VS Code / VSCodium theme via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.vscode = false;
          }
        '';
      };

      emacs = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Emacs theme via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.emacs = false;
          }
        '';
      };

      zed = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Generate Zed editor theme via matugen.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.zed = false;
          }
        '';
      };

      neovim_settings = lib.mkOption {
        default = {
          dark = { baseTheme = "github_dark"; harmony = 0.5; };
          light = { baseTheme = "github_light"; harmony = 0.5; };
        };
        type = lib.types.anything;
        description = "Neovim matugen template settings for dark and light mode variants.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.neovim_settings = {
              dark = { baseTheme = "tokyonight"; harmony = 0.7; };
              light = { baseTheme = "github_light"; harmony = 0.5; };
            };
          }
        '';
      };

      neovim_set_background = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Set Neovim 'background' option (dark/light) via the matugen template.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.dms.app_theming.matugen.neovim_set_background = false;
          }
        '';
      };
    };

  };
}
