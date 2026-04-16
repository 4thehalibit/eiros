# Configures the Dank Material Shell desktop environment, greeter, plugins, and feature flags.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_dms = config.eiros.system.desktop_environment.dank_material_shell;
  helpers = import ../../resources/nix/mangowc_helpers.nix lib;
  inherit (helpers) mangowc_generator keybind_submodule make_mangowc_config;
in
{
  options.eiros.system.desktop_environment.dank_material_shell = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the Eiros Dank Material Shell.";
      example = false;
      type = lib.types.bool;
    };

    systemd = {
      enable = lib.mkOption {
        default = true;
        description = "Enable DankMaterialShell systemd startup.";
        example = false;
        type = lib.types.bool;
      };

      restart_if_changed = lib.mkOption {
        default = true;
        description = "Auto-restart dms.service when dank-material-shell changes.";
        example = false;
        type = lib.types.bool;
      };

      target = lib.mkOption {
        default = "graphical-session.target";
        description = "Systemd target to bind DankMaterialShell to.";
        example = "default.target";
        type = lib.types.str;
      };
    };

    plugins = lib.mkOption {
      default = { };
      description = "DMS plugins to install and enable.";
      example = lib.literalExpression ''
        {
          my-plugin = {
            src = ./my-plugin;
            settings = { theme = "dark"; };
          };
        }
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to enable this plugin.";
              example = false;
            };
            src = lib.mkOption {
              type = lib.types.either lib.types.package lib.types.path;
              description = "Source of the plugin package or path.";
              example = lib.literalExpression "./my-plugin";
            };
            settings = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = "Plugin settings as an attribute set.";
              example = lib.literalExpression ''{ theme = "dark"; }'' ;
            };
          };
        }
      );
    };

    greeter = {
      enable = lib.mkOption {
        default = true;
        description = "Enable the Eiros Dank Material Shell Greeter.";
        example = false;
        type = lib.types.bool;
      };

      compositor = {
        name = lib.mkOption {
          default = "mango";
          description = "Compositor to run the greeter in.";
          example = "sway";
          type = lib.types.enum [
            "niri"
            "hyprland"
            "sway"
            "labwc"
            "mango"
            "scroll"
            "miracle"
          ];
        };
      };

      mango = {
        keyboard_layout = lib.mkOption {
          default = "us";
          description = "Keyboard layout for the greeter's MangoWC.";
          example = "de";
          type = lib.types.str;
        };

        keyboard_variant = lib.mkOption {
          default = "";
          description = "Keyboard layout variant for the greeter's MangoWC.";
          example = "nodeadkeys";
          type = lib.types.str;
        };

        settings = lib.mkOption {
          default = { };
          description = "Raw MangoWC key=value settings for the greeter compositor config.";
          example = lib.literalExpression ''
            {
              border_width = 2;
              gaps_in = 5;
            }
          '';
          type = lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.str
              lib.types.int
              (lib.types.listOf lib.types.str)
            ]
          );
        };

        keybinds = lib.mkOption {
          default = { };
          description = "Structured MangoWC keybind declarations for the greeter.";
          example = lib.literalExpression ''
            {
              close_window = {
                modifier_keys = [ "SUPER" ];
                key_symbol = "q";
                mangowc_command = "killclient";
              };
            }
          '';
          type = lib.types.attrsOf keybind_submodule;
        };
      };

      config_files = lib.mkOption {
        default = [ ];
        description = "Config files to copy into the greeter data directory.";
        example = lib.literalExpression "[ ./dms-config.json ]";
        type = lib.types.listOf lib.types.path;
      };

      config_home = lib.mkOption {
        default = null;
        description = "User home directory to copy DMS configurations for the greeter. If DMS config files are in non-standard locations, use config_files instead.";
        example = "/home/alice";
        type = lib.types.nullOr lib.types.str;
      };

      logs = {
        enable = lib.mkOption {
          default = true;
          description = "Enable logging of greeter messages to a file";
          example = false;
          type = lib.types.bool;
        };

        path = lib.mkOption {
          default = "/tmp/dms-greeter.log";
          description = "Path for the greeter log file.";
          example = "/var/log/dms-greeter.log";
          type = lib.types.str;
        };
      };
    };

    audio_wavelength = {
      enable = lib.mkOption {
        default = false;
        description = "Enable the cava audio visualizer in DMS.";
        example = true;
        type = lib.types.bool;
      };
    };

    calendar_events = {
      enable = lib.mkOption {
        default = false;
        description = "Enable CalDAV calendar synchronization in DMS (requires khal/vdirsyncer setup).";
        example = true;
        type = lib.types.bool;
      };
    };

    clipboard_paste = {
      enable = lib.mkOption {
        default = true;
        description = "Enable clipboard history paste in DMS. Requires wtype.";
        example = false;
        type = lib.types.bool;
      };
    };

    dynamic_theming = {
      enable = lib.mkOption {
        default = true;
        description = "Enable wallpaper-based automatic theming via matugen (GTK, Qt, terminals, Firefox, VSCode).";
        example = false;
        type = lib.types.bool;
      };
    };

    system_monitoring = {
      enable = lib.mkOption {
        default = true;
        description = "Enable system monitoring widget in DMS (CPU, RAM, GPU, temps, processes).";
        example = false;
        type = lib.types.bool;
      };
    };

    vpn = {
      enable = lib.mkOption {
        default = false;
        description = "Enable VPN management widget in DMS.";
        example = true;
        type = lib.types.bool;
      };
    };

    search = {
      enable = lib.mkOption {
        default = true;
        description = "Enable DankSearch.";
        example = false;
        type = lib.types.bool;
      };

      systemd = {
        enable = lib.mkOption {
          default = true;
          description = "Enable the dsearch systemd user service.";
          example = false;
          type = lib.types.bool;
        };

        target = lib.mkOption {
          default = "default.target";
          description = "Systemd target for the dsearch service.";
          example = "graphical-session.target";
          type = lib.types.str;
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf eiros_dms.enable {
      eiros.system.desktop_environment.dank_material_shell.greeter.mango.settings = {
        xkb_rules_layout = eiros_dms.greeter.mango.keyboard_layout;
      }
      // lib.optionalAttrs (eiros_dms.greeter.mango.keyboard_variant != "") {
        xkb_rules_variant = eiros_dms.greeter.mango.keyboard_variant;
      };

      environment.systemPackages = lib.optionals eiros_dms.clipboard_paste.enable [ pkgs.wtype ];

      environment.variables = lib.mkIf eiros_dms.greeter.enable (
        {
          XKB_DEFAULT_LAYOUT = eiros_dms.greeter.mango.keyboard_layout;
        }
        // lib.optionalAttrs (eiros_dms.greeter.mango.keyboard_variant != "") {
          XKB_DEFAULT_VARIANT = eiros_dms.greeter.mango.keyboard_variant;
        }
      );

      programs.dank-material-shell = {
        enable = true;

        enableAudioWavelength = eiros_dms.audio_wavelength.enable;
        enableCalendarEvents = eiros_dms.calendar_events.enable;
        enableClipboardPaste = eiros_dms.clipboard_paste.enable;
        enableDynamicTheming = eiros_dms.dynamic_theming.enable;
        enableSystemMonitoring = eiros_dms.system_monitoring.enable;
        enableVPN = eiros_dms.vpn.enable;

        plugins = eiros_dms.plugins;

        greeter = lib.mkIf eiros_dms.greeter.enable {
          enable = true;

          configFiles = eiros_dms.greeter.config_files;
          configHome = eiros_dms.greeter.config_home;

          logs = lib.mkIf eiros_dms.greeter.logs.enable {
            path = eiros_dms.greeter.logs.path;
            save = true;
          };

          compositor = {
            name = eiros_dms.greeter.compositor.name;
            customConfig = lib.optionalString (eiros_dms.greeter.compositor.name == "mango")
              (mangowc_generator (make_mangowc_config eiros_dms.greeter.mango));
          };
        };

        systemd = {
          enable = eiros_dms.systemd.enable;
          restartIfChanged = eiros_dms.systemd.restart_if_changed;
          target = eiros_dms.systemd.target;
        };
      };
    })

    (lib.mkIf eiros_dms.search.enable {
      programs.dsearch = {
        enable = true;
        systemd = {
          enable = eiros_dms.search.systemd.enable;
          target = eiros_dms.search.systemd.target;
        };
      };
    })
  ];
}
