lib:
let
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
      modifier_keys_str = if kb.modifier_keys == [ ] then "none" else lib.concatStringsSep "+" kb.modifier_keys;
      command_args_str = if kb.command_arguments == null then "" else kb.command_arguments;
    in
    "${modifier_keys_str},${kb.key_symbol},${kb.mangowc_command},${command_args_str}";

  make_mangowc_config =
    mangowc_cfg:
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
      ) { } (lib.attrValues mangowc_cfg.keybinds);
    in
    mangowc_cfg.settings
    // lib.mapAttrs (
      name: lines: (to_string_list (mangowc_cfg.settings.${name} or [ ])) ++ lines
    ) extra_bind_attrs;
in
{
  inherit to_string_list make_bind_line make_mangowc_config;

  mangowc_generator = lib.generators.toKeyValue {
    mkKeyValue =
      name: value:
      if lib.isList value then
        lib.concatMapStringsSep "\n" (v: "${name}=${toString v}") value
      else
        "${name}=${toString value}";
  };

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
}
