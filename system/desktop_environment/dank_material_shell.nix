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
      description = "Enable the Eiros Dank Material Shell";
      type = lib.types.bool;
    };

    greeter = {
      enable = lib.mkOption {
        default = true;
        description = "Enable the Eiros Dank Material Shell Greeter";
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
    search.enable = lib.mkOption {
      default = true;
      description = "Enable DankSearch";
      type = lib.types.bool;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf eiros_dms.enable {
      programs.dank-material-shell = {
        enable = true;

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
