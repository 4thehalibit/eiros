{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_dms = config.eiros.system.desktop_environment.dank_material_shell;

  mangowc_generator = lib.generators.toKeyValue {
    mkKeyValue =
      name: value:
      if lib.isList value then
        lib.concatMapStringsSep "\n" (v: "${name}=${toString v}") value
      else
        "${name}=${toString value}";
  };

  to_string_list =
    v:
    if v == null then
      [ ]
    else if lib.isList v then
      map toString v
    else
      [ (toString v) ];

  make_bind_line =
    kb:
    let
      modifier_keys_str = lib.concatStringsSep "+" kb.modifier_keys;
      command_args_str = if kb.command_arguments == null then "" else kb.command_arguments;
    in
    "${modifier_keys_str},${kb.key_symbol},${kb.mangowc_command},${command_args_str}";

  make_mango_config =
    mango_cfg:
    let
      extra_bind_attrs = builtins.foldl' (
        acc: kb:
        let
          flags_str = lib.concatStrings (kb.flag_modifiers or [ ]);
          bind_key = "bind" + flags_str;
          line = make_bind_line kb;
          previous = acc.${bind_key} or [ ];
        in
        acc // { ${bind_key} = previous ++ [ line ]; }
      ) { } (lib.attrValues mango_cfg.keybinds);
    in
    mango_cfg.settings
    // lib.mapAttrs (
      name: lines: (to_string_list (mango_cfg.settings.${name} or [ ])) ++ lines
    ) extra_bind_attrs;

  keybind_submodule = lib.types.submodule (
    { ... }:
    {
      options = {
        command_arguments = lib.mkOption {
          default = null;
          description = "Optional command arguments.";
          type = lib.types.nullOr lib.types.str;
        };

        flag_modifiers = lib.mkOption {
          default = [ ];
          description = "MangoWC bind flags: l (lock), r (release), s (keysym).";
          example = [ "l" "s" ];
          type = lib.types.listOf (lib.types.enum [ "l" "r" "s" ]);
        };

        key_symbol = lib.mkOption {
          description = "Key symbol such as \"Return\", \"Q\", or \"space\".";
          type = lib.types.str;
        };

        mangowc_command = lib.mkOption {
          description = "MangoWC command (e.g., \"spawn\", \"killclient\", \"quit\").";
          type = lib.types.str;
        };

        modifier_keys = lib.mkOption {
          default = [ ];
          description = "Modifier keys joined using '+', e.g., [\"SUPER\" \"SHIFT\"].";
          type = lib.types.listOf lib.types.str;
        };
      };
    }
  );
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
            customConfig = mangowc_generator (make_mango_config eiros_dms.greeter.mango);
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
