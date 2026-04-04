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
      type = lib.types.bool;
    };

    greeter = {
      enable = lib.mkOption {
        default = true;
        description = "Enable the Eiros Dank Material Shell Greeter.";
        type = lib.types.bool;
      };

      mango = {
        settings = lib.mkOption {
          default = { };
          description = "Raw MangoWC settings for the greeter, written as key=value pairs.";
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
          type = lib.types.attrsOf keybind_submodule;
        };
      };

      logs = {
        enable = lib.mkOption {
          default = true;
          description = "Enable logging of greeter messages to a file";
          type = lib.types.bool;
        };

        path = lib.mkOption {
          default = "/tmp/dms-greeter.log";
          description = "Path for the greeter log file.";
          type = lib.types.str;
        };
      };
    };

    enable_audio_wavelength = lib.mkOption {
      default = false;
      description = "Enable the cava audio visualizer in DMS.";
      type = lib.types.bool;
    };

    enable_calendar_events = lib.mkOption {
      default = false;
      description = "Enable CalDAV calendar synchronization in DMS (requires khal/vdirsyncer setup).";
      type = lib.types.bool;
    };

    enable_clipboard_paste = lib.mkOption {
      default = true;
      description = "Enable clipboard history paste in DMS. Requires wtype.";
      type = lib.types.bool;
    };

    enable_dynamic_theming = lib.mkOption {
      default = true;
      description = "Enable wallpaper-based automatic theming via matugen (GTK, Qt, terminals, Firefox, VSCode).";
      type = lib.types.bool;
    };

    enable_system_monitoring = lib.mkOption {
      default = true;
      description = "Enable system monitoring widget in DMS (CPU, RAM, GPU, temps, processes).";
      type = lib.types.bool;
    };

    enable_vpn = lib.mkOption {
      default = false;
      description = "Enable VPN management widget in DMS.";
      type = lib.types.bool;
    };

    search.enable = lib.mkOption {
      default = true;
      description = "Enable DankSearch.";
      type = lib.types.bool;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf eiros_dms.enable {
      environment.systemPackages = lib.optionals eiros_dms.enable_clipboard_paste [ pkgs.wtype ];

      programs.dank-material-shell = {
        enable = true;

        enableAudioWavelength = eiros_dms.enable_audio_wavelength;
        enableCalendarEvents = eiros_dms.enable_calendar_events;
        enableClipboardPaste = eiros_dms.enable_clipboard_paste;
        enableDynamicTheming = eiros_dms.enable_dynamic_theming;
        enableSystemMonitoring = eiros_dms.enable_system_monitoring;
        enableVPN = eiros_dms.enable_vpn;

        greeter = lib.mkIf eiros_dms.greeter.enable {
          enable = true;

          logs = lib.mkIf eiros_dms.greeter.logs.enable {
            path = eiros_dms.greeter.logs.path;
            save = true;
          };

          compositor = {
            name = "mango";
            customConfig = mangowc_generator (make_mangowc_config eiros_dms.greeter.mango);
          };
        };

        systemd = {
          enable = true;
          restartIfChanged = true;
        };
      };
    })

    (lib.mkIf eiros_dms.search.enable {
      programs.dsearch = {
        enable = true;
        systemd = {
          enable = true;
          target = "default.target";
        };
      };
    })
  ];
}
