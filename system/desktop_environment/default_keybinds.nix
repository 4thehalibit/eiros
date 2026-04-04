{ config, lib, ... }:
let
  helpers = import ../../resources/nix/mangowc_helpers.nix lib;
  inherit (helpers) keybind_submodule;

  dms_enabled = config.eiros.system.desktop_environment.dank_material_shell.enable;

  tags = builtins.genList (i: i + 1) 9;

  view_tag_binds = builtins.listToAttrs (map (tag: {
    name = "view_tag_${toString tag}";
    value = {
      modifier_keys = [ "SUPER" ];
      flag_modifiers = [ "s" ];
      key_symbol = toString tag;
      mangowc_command = "view";
      command_arguments = toString tag;
    };
  }) tags);

  move_to_tag_binds = builtins.listToAttrs (map (tag: {
    name = "move_to_tag_${toString tag}";
    value = {
      modifier_keys = [ "SUPER" "SHIFT" ];
      flag_modifiers = [ ];
      key_symbol = toString tag;
      mangowc_command = "tag";
      command_arguments = toString tag;
    };
  }) tags);

  directional_binds = builtins.listToAttrs (lib.concatLists (map (
    dir:
    let
      key = { left = "h"; right = "l"; up = "k"; down = "j"; }.${dir};
    in
    [
      { name = "switch_focus_${dir}";        value = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = key; mangowc_command = "focusdir";        command_arguments = dir; }; }
      { name = "swap_window_${dir}";         value = { modifier_keys = [ "SUPER" "SHIFT" ]; flag_modifiers = [ "s" ]; key_symbol = key; mangowc_command = "exchange_client"; command_arguments = dir; }; }
      { name = "move_window_monitor_${dir}"; value = { modifier_keys = [ "CTRL" "SHIFT" ];  flag_modifiers = [ "s" ]; key_symbol = key; mangowc_command = "tagmon";          command_arguments = "${dir},1"; }; }
    ]
  ) [ "left" "right" "up" "down" ]));

  static_binds = {
    close_window           = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "q";      mangowc_command = "killclient";           command_arguments = null; };
    quit_mangowc           = { modifier_keys = [ "SUPER" "SHIFT" ]; flag_modifiers = [ "s" ]; key_symbol = "q";      mangowc_command = "quit";                 command_arguments = null; };
    launch_file_browser    = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "f";      mangowc_command = "spawn";                command_arguments = "ghostty -e yazi"; };
    launch_terminal        = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "t";      mangowc_command = "spawn";                command_arguments = "ghostty"; };
    window_toggle_float    = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "g";      mangowc_command = "togglefloating";       command_arguments = null; };
    window_toggle_maximize = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "m";      mangowc_command = "togglemaximizescreen"; command_arguments = null; };
    overview_toggle        = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "Tab";    mangowc_command = "toggleoverview";       command_arguments = null; };
    reload_configuration   = { modifier_keys = [ "SUPER" "SHIFT" ]; flag_modifiers = [ "s" ]; key_symbol = "r";      mangowc_command = "reload_config";        command_arguments = null; };
  };

  dms_binds = lib.optionalAttrs dms_enabled {
    launch_spotlight = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "d";      mangowc_command = "spawn_shell"; command_arguments = "dms ipc call spotlight toggle"; };
    lock_screen      = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "Escape"; mangowc_command = "spawn_shell"; command_arguments = "dms ipc call lock lock"; };
    night_mode       = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "n";      mangowc_command = "spawn_shell"; command_arguments = "dms ipc call night toggle"; };
    screenshot       = { modifier_keys = [ "SUPER" "SHIFT" ]; flag_modifiers = [ "s" ]; key_symbol = "s";      mangowc_command = "spawn_shell"; command_arguments = "dms screenshot --no-file"; };
    paste_clipboard  = { modifier_keys = [ "CTRL" "SHIFT" ];  flag_modifiers = [ "s" ]; key_symbol = "v";      mangowc_command = "spawn_shell"; command_arguments = "dms cl paste | wtype -"; };
  };
in
{
  options.eiros.system.desktop_environment.mangowc.default_keybinds = {
    keybinds = lib.mkOption {
      default = { };
      description = "The resolved set of default MangoWC keybinds. Read this from users.nix to merge with per-user keybinds.";
      type = lib.types.attrsOf keybind_submodule;
    };
  };

  config.eiros.system.desktop_environment.mangowc.default_keybinds.keybinds =
    view_tag_binds // move_to_tag_binds // directional_binds // static_binds // dms_binds;
}
