# Defines the default MangoWC keybind set: tag navigation, window management, media, and DMS actions.
{ config, lib, ... }:
let
  helpers = import ../../../resources/nix/mangowc_helpers.nix lib;
  inherit (helpers) keybind_submodule;

  dms_enabled = config.eiros.system.desktop_environment.dankmaterialshell.enable;
  eiros_commands = config.eiros.system.user_defaults.mangowc.commands;

  eiros_ghostty = config.eiros.system.default_applications.shells.ghostty;
  eiros_yazi    = config.eiros.system.default_applications.file_management.yazi;
  eiros_vivaldi = config.eiros.system.default_applications.browsers.vivaldi;

  tags = builtins.genList (i: i + 1) 9;

  # Generate SUPER+1..9 binds to switch to tags 1–9.
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

  # Generate SUPER+SHIFT+1..9 binds to move the focused window to tags 1–9.
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

  # Generate focus, swap, and monitor-move binds for all four directions (h/j/k/l).
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
    launch_file_browser    = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "f";      mangowc_command = "spawn";                command_arguments = eiros_commands.file_browser; };
    launch_terminal        = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "t";      mangowc_command = "spawn";                command_arguments = eiros_commands.terminal; };
    window_toggle_float    = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "g";      mangowc_command = "togglefloating";       command_arguments = null; };
    window_toggle_maximize = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "m";      mangowc_command = "togglemaximizescreen"; command_arguments = null; };
    overview_toggle        = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "Tab";    mangowc_command = "toggleoverview";       command_arguments = null; };
    reload_configuration   = { modifier_keys = [ "SUPER" "SHIFT" ]; flag_modifiers = [ "s" ]; key_symbol = "r";      mangowc_command = "reload_config";        command_arguments = null; };
  };

  media_binds = {
    volume_up       = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86AudioRaiseVolume";  mangowc_command = "spawn_shell"; command_arguments = "pactl set-sink-volume @DEFAULT_SINK@ +5%"; };
    volume_down     = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86AudioLowerVolume";  mangowc_command = "spawn_shell"; command_arguments = "pactl set-sink-volume @DEFAULT_SINK@ -5%"; };
    volume_mute     = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86AudioMute";         mangowc_command = "spawn_shell"; command_arguments = "pactl set-sink-mute @DEFAULT_SINK@ toggle"; };
    media_play      = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86AudioPlay";         mangowc_command = "spawn_shell"; command_arguments = "playerctl play-pause"; };
    media_next      = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86AudioNext";         mangowc_command = "spawn_shell"; command_arguments = "playerctl next"; };
    media_prev      = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86AudioPrev";         mangowc_command = "spawn_shell"; command_arguments = "playerctl previous"; };
    brightness_up   = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86MonBrightnessUp";   mangowc_command = "spawn_shell"; command_arguments = "brightnessctl set +10%"; };
    brightness_down = { modifier_keys = [ ]; flag_modifiers = [ "s" ]; key_symbol = "XF86MonBrightnessDown"; mangowc_command = "spawn_shell"; command_arguments = "brightnessctl set 10%-"; };
  };

  browser_bind = lib.optionalAttrs eiros_vivaldi.enable {
    launch_browser = { modifier_keys = [ "SUPER" ]; flag_modifiers = [ "s" ]; key_symbol = "b"; mangowc_command = "spawn"; command_arguments = lib.getExe eiros_vivaldi.package; };
  };

  dms_binds = lib.optionalAttrs dms_enabled {
    launch_spotlight = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "d";      mangowc_command = "spawn_shell"; command_arguments = "dms ipc call spotlight toggle"; };
    lock_screen      = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "Escape"; mangowc_command = "spawn_shell"; command_arguments = "dms ipc call lock lock"; };
    night_mode       = { modifier_keys = [ "SUPER" "SHIFT" ]; flag_modifiers = [ "s" ]; key_symbol = "n";      mangowc_command = "spawn_shell"; command_arguments = "dms ipc call night toggle"; };
    notifications    = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "n";      mangowc_command = "spawn_shell"; command_arguments = "dms ipc call notifications toggle"; };
    screenshot       = { modifier_keys = [ "SUPER" "SHIFT" ]; flag_modifiers = [ "s" ]; key_symbol = "s";      mangowc_command = "spawn_shell"; command_arguments = "dms screenshot --no-file"; };
    paste_clipboard  = { modifier_keys = [ "CTRL" "SHIFT" ];  flag_modifiers = [ "s" ]; key_symbol = "v";      mangowc_command = "spawn_shell"; command_arguments = "dms cl paste | wtype -"; };
    clipboard_toggle = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "v";      mangowc_command = "spawn_shell"; command_arguments = "dms ipc call clipboard toggle"; };
    open_settings             = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "comma";  mangowc_command = "spawn_shell"; command_arguments = "dms ipc call settings toggle"; };
    wallpaper_carousel_toggle = { modifier_keys = [ "SUPER" ];         flag_modifiers = [ "s" ]; key_symbol = "w";      mangowc_command = "spawn_shell"; command_arguments = "dms ipc wallpaperCarousel toggle"; };
  };
in
{
  options.eiros.system.user_defaults.mangowc = {
    commands = {
      terminal = lib.mkOption {
        default = if eiros_ghostty.enable then lib.getExe eiros_ghostty.package else "ghostty";
        defaultText = lib.literalExpression ''
          if eiros.system.default_applications.shells.ghostty.enable
          then lib.getExe eiros.system.default_applications.shells.ghostty.package
          else "ghostty"
        '';
        description = "Command used to launch the terminal emulator. Defaults to the ghostty store path when ghostty is enabled.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.mangowc.commands.terminal = "alacritty";
          }
        '';
        type = lib.types.str;
      };

      file_browser = lib.mkOption {
        default =
          if eiros_ghostty.enable && eiros_yazi.enable
          then "${lib.getExe eiros_ghostty.package} -e ${lib.getExe eiros_yazi.package}"
          else "ghostty -e yazi";
        defaultText = lib.literalExpression ''
          if eiros.system.default_applications.shells.ghostty.enable && eiros.system.default_applications.file_management.yazi.enable
          then "''${lib.getExe ghostty.package} -e ''${lib.getExe yazi.package}"
          else "ghostty -e yazi"
        '';
        description = "Command used to launch the file browser. Defaults to ghostty+yazi store paths when both are enabled.";
        example = lib.literalExpression ''
          {
            eiros.system.user_defaults.mangowc.commands.file_browser = "alacritty -e lf";
          }
        '';
        type = lib.types.str;
      };
    };

    keybinds = lib.mkOption {
      default = { };
      description = "The resolved set of default MangoWC keybinds. Read this from users.nix to merge with per-user keybinds.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.mangowc.keybinds = {
            close_window = {
              modifier_keys = [ "SUPER" ];
              key_symbol = "q";
              mangowc_command = "killclient";
            };
          };
        }
      '';
      type = lib.types.attrsOf keybind_submodule;
    };
  };

  config.eiros.system.user_defaults.mangowc.keybinds =
    view_tag_binds // move_to_tag_binds // directional_binds // static_binds // media_binds // dms_binds // browser_bind;
}
