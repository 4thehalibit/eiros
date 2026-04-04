{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_dms = config.eiros.system.desktop_environment.dank_material_shell;

  hypr_value_type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);

  render_hypr_config = import ../../resources/nix/render_hypr_config.nix lib;
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

      hyprland = {
        sections = lib.mkOption {
          default = { };
          description = ''
            Hyprland config sections for the greeter.

            Each section is an attrset of keys to either:
              - a string (single line)
              - a list of strings (repeated key lines)

            Special section name "":
              - renders top-level lines (no section wrapper)
          '';
          type = lib.types.attrsOf (lib.types.attrsOf hypr_value_type);
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
            name = "hyprland";
            customConfig = render_hypr_config eiros_dms.greeter.hyprland.sections;
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
