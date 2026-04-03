{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_dms = config.eiros.system.desktop_environment.dank_material_shell;

  hypr_value_type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);

  to_non_empty_list =
    v:
    let
      list = if lib.isList v then v else [ v ];
    in
    lib.filter (s: s != "") (map toString list);

  render_hypr_config =
    sections:
    let
      render_kv_lines =
        kv:
        let
          pairs = lib.concatLists (
            lib.mapAttrsToList (
              k: v:
              let
                values = to_non_empty_list v;
              in
              map (vv: "${k} = ${vv}") values
            ) kv
          );
        in
        lib.concatStringsSep "\n" pairs;

      indent_lines = s: lib.concatStringsSep "\n" (map (l: "  " + l) (lib.splitString "\n" s));

      render_section =
        section_name: kv:
        let
          body = render_kv_lines kv;
        in
        if body == "" then
          ""
        else if section_name == "" then
          body
        else
          ''
            ${section_name} {
            ${indent_lines body}
            }
          '';
    in
    lib.concatStringsSep "\n\n" (lib.filter (s: s != "") (lib.mapAttrsToList render_section sections));
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
