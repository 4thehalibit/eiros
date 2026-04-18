# Defines system-wide default DMS user settings under eiros.system.user_defaults.dms.
# Every option maps 1:1 to a key in ~/.config/DankMaterialShell/settings.json.
# Defaults match upstream SettingsSpec.js (DankMaterialShell rev 4c2c193).
# The read-only _settings attr assembles all options into the JSON-ready form
# consumed by users/users.nix when writing each user's settings.json.
{ config, lib, ... }:
let
  cfg = config.eiros.system.user_defaults.dms;
in
{
  options.eiros.system.user_defaults.dms = {

    # ── Read-only assembled output ─────────────────────────────────────────
    _settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
      description = "Assembled DMS settings attrs written to ~/.config/DankMaterialShell/settings.json. Do not set this directly — modify the individual options above.";
    };

    # ── Theme ──────────────────────────────────────────────────────────────
    current_theme_name = lib.mkOption {
      default = "purple";
      type = lib.types.str;
      description = "Active DMS built-in theme name (e.g. purple, blue, green, red, orange, yellow, pink, grey) or 'custom' to use customThemeFile.";
    };

    current_theme_category = lib.mkOption {
      default = "generic";
      type = lib.types.str;
      description = "Theme category used for theme registry grouping.";
    };

    custom_theme_file = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Absolute path to a custom theme JSON file. Only used when currentThemeName = \"custom\".";
    };

    registry_theme_variants = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Custom theme variant registry entries.";
    };

    matugen_scheme = lib.mkOption {
      default = "scheme-tonal-spot";
      type = lib.types.str;
      description = "Matugen color generation algorithm. Options: scheme-tonal-spot, scheme-content, scheme-expressive, scheme-fidelity, scheme-fruit-salad, scheme-monochrome, scheme-neutral, scheme-rainbow.";
    };

    matugen_contrast = lib.mkOption {
      default = 0.0;
      type = lib.types.float;
      description = "Matugen contrast level (-1.0 to 1.0). 0 = default contrast.";
    };

    run_user_matugen_templates = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Run user-defined matugen templates on theme or wallpaper change.";
    };

    matugen_target_monitor = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Monitor to sample wallpaper colors from for matugen. Empty = focused monitor.";
    };

    # ── Appearance ─────────────────────────────────────────────────────────
    popup_transparency = lib.mkOption {
      default = 1.0;
      type = lib.types.float;
      description = "Popup and panel background transparency (0.0 = fully transparent, 1.0 = opaque).";
    };

    dock_transparency = lib.mkOption {
      default = 1.0;
      type = lib.types.float;
      description = "Dock background transparency (0.0–1.0).";
    };

    widget_background_color = lib.mkOption {
      default = "sch";
      type = lib.types.str;
      description = "Widget background color token. 'sch' follows the active color scheme.";
    };

    widget_color_mode = lib.mkOption {
      default = "default";
      type = lib.types.str;
      description = "Widget color mode. Options: default, colorful.";
    };

    control_center_tile_color_mode = lib.mkOption {
      default = "primary";
      type = lib.types.str;
      description = "Active tile color mode in the control center.";
    };

    button_color_mode = lib.mkOption {
      default = "primary";
      type = lib.types.str;
      description = "Button accent color mode.";
    };

    corner_radius = lib.mkOption {
      default = 16;
      type = lib.types.int;
      description = "Global corner radius in pixels for widgets, popups, and panels.";
    };

    # ── Compositor layout overrides ────────────────────────────────────────
    niri_layout_gaps_override = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override Niri window gaps (px). -1 = use compositor default.";
    };

    niri_layout_radius_override = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override Niri window corner radius. -1 = use compositor default.";
    };

    niri_layout_border_size = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override Niri window border size (px). -1 = use compositor default.";
    };

    hyprland_layout_gaps_override = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override Hyprland window gaps. -1 = use compositor default.";
    };

    hyprland_layout_radius_override = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override Hyprland window corner radius. -1 = use compositor default.";
    };

    hyprland_layout_border_size = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override Hyprland window border size. -1 = use compositor default.";
    };

    mango_layout_gaps_override = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override MangoWC window gaps (px). -1 = use compositor default.";
    };

    mango_layout_radius_override = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override MangoWC window corner radius. -1 = use compositor default.";
    };

    mango_layout_border_size = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "Override MangoWC window border size (px). -1 = use compositor default.";
    };

    # ── Animations ─────────────────────────────────────────────────────────
    animation_speed = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Global animation speed preset. 0=None, 1=Short, 2=Medium, 3=Long, 4=Custom.";
    };

    custom_animation_duration = lib.mkOption {
      default = 500;
      type = lib.types.int;
      description = "Custom global animation duration in milliseconds (used when animationSpeed = 4).";
    };

    sync_component_animation_speeds = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Sync popout and modal animation speeds with the global animationSpeed.";
    };

    popout_animation_speed = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Popout widget animation speed. 0=None, 1=Short, 2=Medium, 3=Long, 4=Custom.";
    };

    popout_custom_animation_duration = lib.mkOption {
      default = 150;
      type = lib.types.int;
      description = "Custom popout animation duration in milliseconds.";
    };

    modal_animation_speed = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Modal dialog animation speed. 0=None, 1=Short, 2=Medium, 3=Long, 4=Custom.";
    };

    modal_custom_animation_duration = lib.mkOption {
      default = 150;
      type = lib.types.int;
      description = "Custom modal animation duration in milliseconds.";
    };

    enable_ripple_effects = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Enable Material 3 ripple click effects on interactive elements.";
    };

    # ── Elevation (shadows) ────────────────────────────────────────────────
    m3_elevation_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Enable Material 3 elevation shadows on widgets.";
    };

    m3_elevation_intensity = lib.mkOption {
      default = 12;
      type = lib.types.int;
      description = "Elevation shadow spread intensity (0–100).";
    };

    m3_elevation_opacity = lib.mkOption {
      default = 30;
      type = lib.types.int;
      description = "Elevation shadow opacity (0–100).";
    };

    m3_elevation_color_mode = lib.mkOption {
      default = "default";
      type = lib.types.str;
      description = "Elevation shadow color mode. Options: default, custom.";
    };

    m3_elevation_light_direction = lib.mkOption {
      default = "top";
      type = lib.types.str;
      description = "Simulated light direction for elevation shadows. Options: top, bottom, left, right.";
    };

    m3_elevation_custom_color = lib.mkOption {
      default = "#000000";
      type = lib.types.str;
      description = "Custom elevation shadow color (hex). Used when m3ElevationColorMode = \"custom\".";
    };

    modal_elevation_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Apply elevation shadows to modal dialogs.";
    };

    popout_elevation_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Apply elevation shadows to popout widgets.";
    };

    bar_elevation_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Apply elevation shadow to the bar.";
    };

    # ── Blur ───────────────────────────────────────────────────────────────
    blur_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable background blur on widgets and panels (requires compositor blur support).";
    };

    blur_border_color = lib.mkOption {
      default = "outline";
      type = lib.types.str;
      description = "Color token for the blur border.";
    };

    blur_border_custom_color = lib.mkOption {
      default = "#ffffff";
      type = lib.types.str;
      description = "Custom blur border color (hex).";
    };

    blur_border_opacity = lib.mkOption {
      default = 1.0;
      type = lib.types.float;
      description = "Blur border opacity (0.0–1.0).";
    };

    wallpaper_fill_mode = lib.mkOption {
      default = "Fill";
      type = lib.types.str;
      description = "Wallpaper fill mode. Options: Fill, Fit, Stretch, Crop, Tile.";
    };

    blurred_wallpaper_layer = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Render a blurred wallpaper layer behind transparent panels.";
    };

    blur_wallpaper_on_overview = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Blur the wallpaper when the overview/expo is open.";
    };

    # ── Bar widget visibility ──────────────────────────────────────────────
    show_launcher_button = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the app launcher button in the bar.";
    };

    show_workspace_switcher = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the workspace switcher in the bar.";
    };

    show_focused_window = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the focused window title/icon in the bar.";
    };

    show_weather = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the weather widget in the bar.";
    };

    show_music = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the media player widget in the bar.";
    };

    show_clipboard = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the clipboard history widget in the bar.";
    };

    show_cpu_usage = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the CPU usage widget in the bar.";
    };

    show_mem_usage = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the memory usage widget in the bar.";
    };

    show_cpu_temp = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the CPU temperature widget in the bar.";
    };

    show_gpu_temp = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the GPU temperature widget in the bar.";
    };

    selected_gpu_index = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Index of the GPU to display temperature for (0-based).";
    };

    enabled_gpu_pci_ids = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.str;
      description = "PCI IDs of GPUs to include in monitoring widgets.";
    };

    show_system_tray = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the system tray in the bar.";
    };

    show_clock = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the clock widget in the bar.";
    };

    show_notification_button = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the notification center toggle button in the bar.";
    };

    show_battery = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the battery indicator in the bar.";
    };

    show_control_center_button = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the control center toggle button in the bar.";
    };

    show_caps_lock_indicator = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the caps lock indicator in the bar.";
    };

    # ── Control center ─────────────────────────────────────────────────────
    control_center_show_network_icon = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the network icon in the control center header.";
    };

    control_center_show_bluetooth_icon = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the Bluetooth icon in the control center header.";
    };

    control_center_show_audio_icon = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the audio icon in the control center header.";
    };

    control_center_show_audio_percent = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show audio volume percentage next to the audio icon.";
    };

    control_center_show_vpn_icon = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the VPN icon in the control center header.";
    };

    control_center_show_brightness_icon = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show the brightness icon in the control center header.";
    };

    control_center_show_brightness_percent = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show brightness percentage next to the brightness icon.";
    };

    control_center_show_mic_icon = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show the microphone icon in the control center header.";
    };

    control_center_show_mic_percent = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show microphone volume percentage next to the mic icon.";
    };

    control_center_show_battery_icon = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show the battery icon in the control center header.";
    };

    control_center_show_printer_icon = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show the printer icon in the control center header.";
    };

    control_center_show_screen_sharing_icon = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the screen sharing icon in the control center header.";
    };

    show_privacy_button = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the privacy indicator button in the bar.";
    };

    privacy_show_mic_icon = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show microphone-in-use indicator in the privacy button.";
    };

    privacy_show_camera_icon = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show camera-in-use indicator in the privacy button.";
    };

    privacy_show_screen_share_icon = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show screen-sharing indicator in the privacy button.";
    };

    control_center_widgets = lib.mkOption {
      default = [
        { id = "volumeSlider"; enabled = true; width = 50; }
        { id = "brightnessSlider"; enabled = true; width = 50; }
        { id = "wifi"; enabled = true; width = 50; }
        { id = "bluetooth"; enabled = true; width = 50; }
        { id = "audioOutput"; enabled = true; width = 50; }
        { id = "audioInput"; enabled = true; width = 50; }
        { id = "nightMode"; enabled = true; width = 50; }
        { id = "darkMode"; enabled = true; width = 50; }
      ];
      type = lib.types.listOf lib.types.anything;
      description = "Ordered list of control center tile widgets with enabled/width configuration.";
    };

    # ── Workspaces ─────────────────────────────────────────────────────────
    show_workspace_index = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show workspace index number on workspace indicators.";
    };

    show_workspace_name = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show workspace name on workspace indicators.";
    };

    show_workspace_padding = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Add extra padding around workspace indicators.";
    };

    workspace_scrolling = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Scroll through workspaces by scrolling on the workspace switcher.";
    };

    show_workspace_apps = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show app icons inside workspace indicators.";
    };

    workspace_drag_reorder = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Allow dragging workspace indicators to reorder workspaces.";
    };

    max_workspace_icons = lib.mkOption {
      default = 3;
      type = lib.types.int;
      description = "Maximum number of app icons shown per workspace indicator.";
    };

    workspace_app_icon_size_offset = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Size offset for app icons inside workspace indicators (pixels).";
    };

    group_workspace_apps = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Group duplicate app icons in workspace indicators.";
    };

    workspace_follow_focus = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Auto-scroll the workspace switcher to follow the focused workspace.";
    };

    show_occupied_workspaces_only = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Only show occupied workspaces in the workspace switcher.";
    };

    reverse_scrolling = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Reverse scroll direction on the workspace switcher.";
    };

    dwl_show_all_tags = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show all DWL tags, not just active ones.";
    };

    workspace_active_app_highlight_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Highlight the active app icon in workspace indicators.";
    };

    workspace_color_mode = lib.mkOption {
      default = "default";
      type = lib.types.str;
      description = "Color mode for the focused workspace indicator.";
    };

    workspace_occupied_color_mode = lib.mkOption {
      default = "none";
      type = lib.types.str;
      description = "Color mode for occupied (non-focused) workspace indicators.";
    };

    workspace_unfocused_color_mode = lib.mkOption {
      default = "default";
      type = lib.types.str;
      description = "Color mode for unfocused workspace indicators.";
    };

    workspace_urgent_color_mode = lib.mkOption {
      default = "default";
      type = lib.types.str;
      description = "Color mode for urgent workspace indicators.";
    };

    workspace_focused_border_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show a border around the focused workspace indicator.";
    };

    workspace_focused_border_color = lib.mkOption {
      default = "primary";
      type = lib.types.str;
      description = "Border color token for the focused workspace indicator.";
    };

    workspace_focused_border_thickness = lib.mkOption {
      default = 2;
      type = lib.types.int;
      description = "Border thickness for the focused workspace indicator (pixels).";
    };

    workspace_name_icons = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      description = "Map of workspace name to icon character (e.g. { \"1\" = \"\"; }).";
    };

    # ── Bar widget behavior ────────────────────────────────────────────────
    wave_progress_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Enable the wave progress animation on the media player widget.";
    };

    scroll_title_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Enable scrolling for long window titles in the focused window widget.";
    };

    media_adaptive_width_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Let the media player widget adapt its width to content.";
    };

    audio_visualizer_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show an audio waveform visualizer in the media player widget.";
    };

    audio_scroll_mode = lib.mkOption {
      default = "volume";
      type = lib.types.str;
      description = "What scrolling on the audio widget controls. Options: volume, seek.";
    };

    audio_wheel_scroll_amount = lib.mkOption {
      default = 5;
      type = lib.types.int;
      description = "Volume change per scroll step (percent).";
    };

    clock_compact_mode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Compact clock mode (time only, no date).";
    };

    focused_window_compact_mode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Compact focused window widget (icon only, no title).";
    };

    running_apps_compact_mode = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Compact running apps widget (icons only, no labels).";
    };

    bar_max_visible_apps = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Maximum pinned apps shown in the bar. 0 = unlimited.";
    };

    bar_max_visible_running_apps = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Maximum running apps shown in the bar. 0 = unlimited.";
    };

    bar_show_overflow_badge = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show an overflow badge when the app limit is exceeded.";
    };

    apps_dock_hide_indicators = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Hide running/open indicators on dock and bar app icons.";
    };

    apps_dock_colorize_active = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Colorize the active app indicator.";
    };

    apps_dock_active_color_mode = lib.mkOption {
      default = "primary";
      type = lib.types.str;
      description = "Color mode for the active app indicator.";
    };

    apps_dock_enlarge_on_hover = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enlarge dock/bar app icons on hover.";
    };

    apps_dock_enlarge_percentage = lib.mkOption {
      default = 125;
      type = lib.types.int;
      description = "Hover enlargement percentage for app icons.";
    };

    apps_dock_icon_size_percentage = lib.mkOption {
      default = 100;
      type = lib.types.int;
      description = "Base icon size as a percentage of the default.";
    };

    keyboard_layout_name_compact_mode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show short keyboard layout name (e.g. US instead of English (US)).";
    };

    running_apps_current_workspace = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Only show running apps from the current workspace.";
    };

    running_apps_group_by_app = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Group multiple windows of the same app in the running apps widget.";
    };

    running_apps_current_monitor = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Only show running apps from the current monitor.";
    };

    # ── App ID substitutions ───────────────────────────────────────────────
    app_id_substitutions = lib.mkOption {
      default = [
        { pattern = "Spotify"; replacement = "spotify"; type = "exact"; }
        { pattern = "beepertexts"; replacement = "beeper"; type = "exact"; }
        { pattern = "home assistant desktop"; replacement = "homeassistant-desktop"; type = "exact"; }
        { pattern = "com.transmissionbt.transmission"; replacement = "transmission-gtk"; type = "contains"; }
        { pattern = "^steam_app_(\\d+)$"; replacement = "steam_icon_$1"; type = "regex"; }
      ];
      type = lib.types.listOf lib.types.anything;
      description = "Rules for resolving app IDs to icon names. type: exact | contains | regex.";
    };

    centering_mode = lib.mkOption {
      default = "index";
      type = lib.types.str;
      description = "Bar centering mode for the center widget group. Options: index, smart.";
    };

    # ── Bar configs ────────────────────────────────────────────────────────
    bar_configs = lib.mkOption {
      default = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
          leftWidgets = [ "launcherButton" "workspaceSwitcher" "focusedWindow" ];
          centerWidgets = [ "music" "clock" "weather" ];
          rightWidgets = [ "systemTray" "clipboard" "cpuUsage" "memUsage" "notificationButton" "battery" "controlCenterButton" ];
          spacing = 4;
          innerPadding = 4;
          bottomGap = 0;
          transparency = 1.0;
          widgetTransparency = 1.0;
          squareCorners = false;
          noBackground = false;
          maximizeWidgetIcons = false;
          maximizeWidgetText = false;
          removeWidgetPadding = false;
          widgetPadding = 8;
          gothCornersEnabled = false;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          borderEnabled = false;
          borderColor = "surfaceText";
          borderOpacity = 1.0;
          borderThickness = 1;
          widgetOutlineEnabled = false;
          widgetOutlineColor = "primary";
          widgetOutlineOpacity = 1.0;
          widgetOutlineThickness = 1;
          fontScale = 1.0;
          iconScale = 1.0;
          autoHide = false;
          autoHideDelay = 250;
          showOnWindowsOpen = false;
          openOnOverview = false;
          visible = true;
          popupGapsAuto = true;
          popupGapsManual = 4;
          maximizeDetection = true;
          scrollEnabled = true;
          scrollXBehavior = "column";
          scrollYBehavior = "workspace";
          shadowIntensity = 0;
          shadowOpacity = 60;
          shadowColorMode = "default";
          shadowCustomColor = "#000000";
          clickThrough = false;
        }
      ];
      type = lib.types.listOf lib.types.anything;
      description = "Bar configuration objects. Each entry defines a bar instance with widget layout, position, styling, and behavior.";
    };

    # ── Fonts ──────────────────────────────────────────────────────────────
    font_family = lib.mkOption {
      default = "Inter Variable";
      type = lib.types.str;
      description = "Primary UI font family.";
    };

    mono_font_family = lib.mkOption {
      default = "Fira Code";
      type = lib.types.str;
      description = "Monospace font family used in terminal and code widgets.";
    };

    font_weight = lib.mkOption {
      default = 400;
      type = lib.types.int;
      description = "Global UI font weight (100–900). 400 = Normal, 700 = Bold.";
    };

    font_scale = lib.mkOption {
      default = 1.0;
      type = lib.types.float;
      description = "Global UI font scale multiplier.";
    };

    # ── Clock & date ───────────────────────────────────────────────────────
    use24_hour_clock = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Use 24-hour time format.";
    };

    show_seconds = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show seconds in the clock widget.";
    };

    pad_hours12_hour = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Zero-pad hours in 12-hour format (e.g. 09:00 instead of 9:00).";
    };

    clock_date_format = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom Qt date format string for the bar clock. Empty = locale default.";
    };

    lock_date_format = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom Qt date format string for the lock screen. Empty = locale default.";
    };

    first_day_of_week = lib.mkOption {
      default = -1;
      type = lib.types.int;
      description = "First day of the week in the calendar. -1 = locale default, 0 = Sunday, 1 = Monday.";
    };

    show_week_number = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show ISO week numbers in the calendar popup.";
    };

    night_mode_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable night mode (blue-light filter) by default on login.";
    };

    # ── Weather ────────────────────────────────────────────────────────────
    use_fahrenheit = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Display temperatures in Fahrenheit (default: Celsius).";
    };

    wind_speed_unit = lib.mkOption {
      default = "kmh";
      type = lib.types.str;
      description = "Wind speed unit. Options: kmh, mph, ms, kn.";
    };

    use_auto_location = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Automatically detect location for weather data.";
    };

    weather_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Enable the weather widget.";
    };

    # ── Media ──────────────────────────────────────────────────────────────
    media_size = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Media player widget size. 0 = Small, 1 = Medium, 2 = Large.";
    };

    # ── Sounds ─────────────────────────────────────────────────────────────
    sounds_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Enable DMS UI sound effects.";
    };

    use_system_sound_theme = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Use the system sound theme instead of DMS built-in sounds.";
    };

    sound_login = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Play a sound on login.";
    };

    sound_new_notification = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Play a sound for incoming notifications.";
    };

    sound_volume_changed = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Play a sound when volume changes.";
    };

    sound_plugged_in = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Play a sound when a charger is connected.";
    };

    # ── Notifications ──────────────────────────────────────────────────────
    notification_timeout_low = lib.mkOption {
      default = 5000;
      type = lib.types.int;
      description = "Auto-dismiss timeout for low-urgency notifications (ms). 0 = never.";
    };

    notification_timeout_normal = lib.mkOption {
      default = 5000;
      type = lib.types.int;
      description = "Auto-dismiss timeout for normal-urgency notifications (ms). 0 = never.";
    };

    notification_timeout_critical = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Auto-dismiss timeout for critical notifications (ms). 0 = never.";
    };

    notification_compact_mode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Use compact display for notification popups.";
    };

    notification_popup_position = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Notification popup screen position. 0=Top, 1=Bottom, 2=Left, 3=Right, 4=TopCenter, 5=BottomCenter, 6=LeftCenter, 7=RightCenter.";
    };

    notification_animation_speed = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Notification popup animation speed. 0=None, 1=Short, 2=Medium, 3=Long, 4=Custom.";
    };

    notification_custom_animation_duration = lib.mkOption {
      default = 400;
      type = lib.types.int;
      description = "Custom notification animation duration (ms).";
    };

    notification_history_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Persist notifications in the notification center history.";
    };

    notification_history_max_count = lib.mkOption {
      default = 50;
      type = lib.types.int;
      description = "Maximum number of notifications kept in history.";
    };

    notification_history_max_age_days = lib.mkOption {
      default = 7;
      type = lib.types.int;
      description = "Maximum age (days) for history entries. 0 = unlimited.";
    };

    notification_history_save_low = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Save low-urgency notifications to history.";
    };

    notification_history_save_normal = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Save normal-urgency notifications to history.";
    };

    notification_history_save_critical = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Save critical notifications to history.";
    };

    notification_rules = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.anything;
      description = "Custom notification filter/routing rules.";
    };

    notification_focused_monitor = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Only show notification popups on the currently focused monitor.";
    };

    notification_overlay_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show notifications as a persistent overlay instead of dismissable popups.";
    };

    notification_popup_shadow_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show a drop shadow under notification popups.";
    };

    notification_popup_privacy_mode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Hide notification body in popups (show app name only).";
    };

    # ── OSD ────────────────────────────────────────────────────────────────
    osd_always_show_value = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Always show the current value in OSD indicators, not just on change.";
    };

    osd_position = lib.mkOption {
      default = 5;
      type = lib.types.int;
      description = "OSD screen position. 0=Top, 1=Bottom, 2=Left, 3=Right, 4=TopCenter, 5=BottomCenter, 6=LeftCenter, 7=RightCenter.";
    };

    osd_volume_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show OSD when volume changes.";
    };

    osd_media_volume_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show OSD when media volume changes.";
    };

    osd_media_playback_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show OSD on media playback changes (play/pause/skip).";
    };

    osd_brightness_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show OSD when screen brightness changes.";
    };

    osd_idle_inhibitor_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show OSD when the idle inhibitor state changes.";
    };

    osd_mic_mute_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show OSD when the microphone is muted or unmuted.";
    };

    osd_caps_lock_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show OSD when caps lock toggles.";
    };

    osd_power_profile_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show OSD when the power profile changes.";
    };

    osd_audio_output_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show OSD when the audio output device changes.";
    };

    # ── Lock screen ────────────────────────────────────────────────────────
    lock_screen_show_power_actions = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show power action buttons on the lock screen.";
    };

    lock_screen_show_system_icons = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show system status icons (network, battery) on the lock screen.";
    };

    lock_screen_show_time = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the current time on the lock screen.";
    };

    lock_screen_show_date = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the current date on the lock screen.";
    };

    lock_screen_show_profile_image = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the user avatar on the lock screen.";
    };

    lock_screen_show_password_field = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the password input field on the lock screen.";
    };

    lock_screen_show_media_player = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the media player controls on the lock screen.";
    };

    lock_screen_power_off_monitors_on_lock = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Turn off all monitors immediately when the screen locks.";
    };

    lock_at_startup = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Lock the screen when DMS starts.";
    };

    lock_screen_active_monitor = lib.mkOption {
      default = "all";
      type = lib.types.str;
      description = "Which monitors display the lock screen. Options: all, focused, primary.";
    };

    lock_screen_inactive_color = lib.mkOption {
      default = "#000000";
      type = lib.types.str;
      description = "Background color shown on inactive monitors during lock (hex).";
    };

    lock_screen_notification_mode = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Notification display on lock screen. 0 = None, 1 = Count, 2 = Full.";
    };

    lock_screen_video_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Use a video as the lock screen background.";
    };

    lock_screen_video_path = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Absolute path to the lock screen background video.";
    };

    lock_screen_video_cycling = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Cycle through multiple videos as lock screen backgrounds.";
    };

    fade_to_lock_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Fade the screen before locking.";
    };

    fade_to_lock_grace_period = lib.mkOption {
      default = 5;
      type = lib.types.int;
      description = "Seconds before the screen fades prior to locking.";
    };

    fade_to_dpms_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Fade the screen before monitors turn off (DPMS).";
    };

    fade_to_dpms_grace_period = lib.mkOption {
      default = 5;
      type = lib.types.int;
      description = "Seconds before the screen fades prior to DPMS off.";
    };

    enable_fprint = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable fingerprint authentication on the lock screen.";
    };

    max_fprint_tries = lib.mkOption {
      default = 15;
      type = lib.types.int;
      description = "Maximum fingerprint attempts before falling back to password.";
    };

    enable_u2f = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable U2F/FIDO2 key authentication on the lock screen.";
    };

    u2f_mode = lib.mkOption {
      default = "or";
      type = lib.types.str;
      description = "U2F authentication mode. Options: or (key OR password), and (key AND password).";
    };

    hide_brightness_slider = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Hide the brightness slider on the lock screen.";
    };

    loginctl_lock_integration = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Respond to loginctl lock-session events.";
    };

    lock_before_suspend = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Lock the screen before suspending.";
    };

    modal_darken_background = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Darken the background when a modal dialog is open.";
    };

    # ── Power management ───────────────────────────────────────────────────
    ac_monitor_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Idle seconds before monitors turn off on AC power. 0 = never.";
    };

    ac_lock_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Idle seconds before locking on AC power. 0 = never.";
    };

    ac_suspend_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Idle seconds before suspending on AC power. 0 = never.";
    };

    ac_suspend_behavior = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Suspend action on AC power. 0 = Suspend, 1 = Hibernate, 2 = SuspendThenHibernate.";
    };

    ac_profile_name = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Power profile to activate on AC power (e.g. performance, balanced, power-saver).";
    };

    ac_post_lock_monitor_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Seconds after locking before monitors turn off on AC. 0 = never.";
    };

    battery_monitor_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Idle seconds before monitors turn off on battery. 0 = never.";
    };

    battery_lock_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Idle seconds before locking on battery. 0 = never.";
    };

    battery_suspend_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Idle seconds before suspending on battery. 0 = never.";
    };

    battery_suspend_behavior = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Suspend action on battery. 0 = Suspend, 1 = Hibernate, 2 = SuspendThenHibernate.";
    };

    battery_profile_name = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Power profile to activate on battery.";
    };

    battery_post_lock_monitor_timeout = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Seconds after locking before monitors turn off on battery. 0 = never.";
    };

    battery_charge_limit = lib.mkOption {
      default = 100;
      type = lib.types.int;
      description = "Battery charge limit percentage (50–100).";
    };

    # ── Power menu ─────────────────────────────────────────────────────────
    power_action_confirm = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Require holding a button to confirm power menu actions.";
    };

    power_action_hold_duration = lib.mkOption {
      default = 0.5;
      type = lib.types.float;
      description = "Hold duration in seconds to confirm a power action.";
    };

    power_menu_actions = lib.mkOption {
      default = [ "reboot" "logout" "poweroff" "lock" "suspend" "restart" ];
      type = lib.types.listOf lib.types.str;
      description = "Ordered list of actions shown in the power menu.";
    };

    power_menu_default_action = lib.mkOption {
      default = "logout";
      type = lib.types.str;
      description = "Default highlighted action in the power menu.";
    };

    power_menu_grid_layout = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Use a grid layout for the power menu instead of a list.";
    };

    custom_power_action_lock = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command for the lock action. Empty = DMS default.";
    };

    custom_power_action_logout = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command for the logout action. Empty = DMS default.";
    };

    custom_power_action_suspend = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command for the suspend action. Empty = DMS default.";
    };

    custom_power_action_hibernate = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command for the hibernate action. Empty = DMS default.";
    };

    custom_power_action_reboot = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command for the reboot action. Empty = DMS default.";
    };

    custom_power_action_power_off = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command for the power-off action. Empty = DMS default.";
    };

    # ── Application theming ────────────────────────────────────────────────
    gtk_theming_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Apply the active DMS color scheme to GTK 3/4 applications via matugen.";
    };

    qt_theming_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Apply the active DMS color scheme to Qt applications via qt5ct/qt6ct.";
    };

    sync_mode_with_portal = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Sync dark/light mode with the XDG desktop portal (benefits Flatpak apps).";
    };

    terminals_always_dark = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Always use the dark color variant for terminal applications even in light mode.";
    };

    icon_theme = lib.mkOption {
      default = "System Default";
      type = lib.types.str;
      description = "Icon theme name. \"System Default\" defers to the platform theme (QT_QPA_PLATFORMTHEME).";
    };

    network_preference = lib.mkOption {
      default = "auto";
      type = lib.types.str;
      description = "Preferred network display type. Options: auto, wifi, ethernet.";
    };

    # ── Matugen template toggles ───────────────────────────────────────────
    run_dms_matugen_templates = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Run all DMS-provided matugen templates on theme or wallpaper change.";
    };

    matugen_template_gtk = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate GTK theme colors via matugen.";
    };

    matugen_template_niri = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Niri compositor color config via matugen.";
    };

    matugen_template_hyprland = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Hyprland compositor color config via matugen.";
    };

    matugen_template_mangowc = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate MangoWC compositor color config via matugen.";
    };

    matugen_template_qt5ct = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate qt5ct color palette via matugen.";
    };

    matugen_template_qt6ct = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate qt6ct color palette via matugen.";
    };

    matugen_template_firefox = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Firefox theme colors via matugen (requires MaterialFox or compatible theme).";
    };

    matugen_template_pywalfox = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Pywalfox Firefox theme colors via matugen.";
    };

    matugen_template_zen_browser = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Zen Browser theme colors via matugen.";
    };

    matugen_template_vesktop = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Vesktop (Discord) theme colors via matugen.";
    };

    matugen_template_equibop = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Equibop (Discord) theme colors via matugen.";
    };

    matugen_template_ghostty = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Ghostty terminal colors via matugen.";
    };

    matugen_template_kitty = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Kitty terminal colors via matugen.";
    };

    matugen_template_foot = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Foot terminal colors via matugen.";
    };

    matugen_template_alacritty = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Alacritty terminal colors via matugen.";
    };

    matugen_template_neovim = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Generate Neovim color scheme via matugen.";
    };

    matugen_template_wezterm = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate WezTerm terminal colors via matugen.";
    };

    matugen_template_dgop = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate dgop (GTK color override proxy) colors via matugen.";
    };

    matugen_template_kcolorscheme = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate KDE color scheme via matugen.";
    };

    matugen_template_vscode = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate VS Code / VSCodium theme via matugen.";
    };

    matugen_template_emacs = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Emacs theme via matugen.";
    };

    matugen_template_zed = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Generate Zed editor theme via matugen.";
    };

    matugen_template_neovim_settings = lib.mkOption {
      default = {
        dark = { baseTheme = "github_dark"; harmony = 0.5; };
        light = { baseTheme = "github_light"; harmony = 0.5; };
      };
      type = lib.types.anything;
      description = "Neovim matugen template settings for dark and light mode variants.";
    };

    matugen_template_neovim_set_background = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Set Neovim 'background' option (dark/light) via the matugen template.";
    };

    # ── Dock ───────────────────────────────────────────────────────────────
    show_dock = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show the application dock.";
    };

    dock_auto_hide = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Auto-hide the dock when overlapped by windows.";
    };

    dock_smart_auto_hide = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Smart auto-hide: only hide when a maximized window is present.";
    };

    dock_group_by_app = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Group multiple windows of the same app into one dock icon.";
    };

    dock_restore_special_workspace_on_click = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Restore an app from a special workspace when clicking its dock icon.";
    };

    dock_open_on_overview = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show the dock when the overview/expo is open.";
    };

    dock_position = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Dock screen edge. 0 = Top, 1 = Bottom, 2 = Left, 3 = Right.";
    };

    dock_spacing = lib.mkOption {
      default = 4.0;
      type = lib.types.float;
      description = "Spacing between dock icons (pixels).";
    };

    dock_bottom_gap = lib.mkOption {
      default = 0.0;
      type = lib.types.float;
      description = "Gap between the dock and the screen edge (pixels).";
    };

    dock_margin = lib.mkOption {
      default = 0.0;
      type = lib.types.float;
      description = "Outer margin around the dock (pixels).";
    };

    dock_icon_size = lib.mkOption {
      default = 40.0;
      type = lib.types.float;
      description = "Dock icon size (pixels).";
    };

    dock_indicator_style = lib.mkOption {
      default = "circle";
      type = lib.types.str;
      description = "Running app indicator style. Options: circle, bar, none.";
    };

    dock_border_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show a border around the dock.";
    };

    dock_border_color = lib.mkOption {
      default = "surfaceText";
      type = lib.types.str;
      description = "Dock border color token.";
    };

    dock_border_opacity = lib.mkOption {
      default = 1.0;
      type = lib.types.float;
      description = "Dock border opacity (0.0–1.0).";
    };

    dock_border_thickness = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Dock border thickness (pixels).";
    };

    dock_isolate_displays = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show only windows from the current display in the dock.";
    };

    dock_launcher_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show a launcher button inside the dock.";
    };

    dock_launcher_logo_mode = lib.mkOption {
      default = "apps";
      type = lib.types.str;
      description = "Dock launcher logo mode. Options: apps, custom.";
    };

    dock_launcher_logo_custom_path = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Path to custom dock launcher logo image.";
    };

    dock_launcher_logo_color_override = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Color override for dock launcher logo (hex). Empty = theme color.";
    };

    dock_launcher_logo_size_offset = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Size offset for the dock launcher logo (pixels).";
    };

    dock_launcher_logo_brightness = lib.mkOption {
      default = 0.5;
      type = lib.types.float;
      description = "Dock launcher logo brightness (0.0–1.0).";
    };

    dock_launcher_logo_contrast = lib.mkOption {
      default = 1.0;
      type = lib.types.float;
      description = "Dock launcher logo contrast multiplier.";
    };

    dock_max_visible_apps = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Maximum pinned apps shown in the dock. 0 = unlimited.";
    };

    dock_max_visible_running_apps = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Maximum running apps shown in the dock. 0 = unlimited.";
    };

    dock_show_overflow_badge = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show an overflow badge when the dock app limit is exceeded.";
    };

    # ── Launcher / Spotlight ───────────────────────────────────────────────
    app_launcher_view_mode = lib.mkOption {
      default = "list";
      type = lib.types.str;
      description = "App launcher default view mode. Options: list, grid.";
    };

    spotlight_modal_view_mode = lib.mkOption {
      default = "list";
      type = lib.types.str;
      description = "Spotlight search default view mode. Options: list, grid.";
    };

    browser_picker_view_mode = lib.mkOption {
      default = "grid";
      type = lib.types.str;
      description = "Browser picker view mode. Options: list, grid.";
    };

    browser_usage_history = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Browser usage history for frequency-based ordering.";
    };

    app_picker_view_mode = lib.mkOption {
      default = "grid";
      type = lib.types.str;
      description = "App picker view mode. Options: list, grid.";
    };

    file_picker_usage_history = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "File picker usage history.";
    };

    sort_apps_alphabetically = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Sort apps alphabetically in the launcher instead of by frequency.";
    };

    app_launcher_grid_columns = lib.mkOption {
      default = 4;
      type = lib.types.int;
      description = "Number of columns in the app launcher grid view.";
    };

    spotlight_close_niri_overview = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Close the Niri overview when spotlight opens.";
    };

    remember_last_query = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Remember the last spotlight search query between opens.";
    };

    spotlight_section_view_modes = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Per-section view mode overrides for spotlight search results.";
    };

    app_drawer_section_view_modes = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Per-section view mode overrides for the app drawer.";
    };

    niri_overview_overlay_enabled = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the DMS overlay (bar, dock) when the Niri overview is open.";
    };

    dank_launcher_v2_size = lib.mkOption {
      default = "compact";
      type = lib.types.str;
      description = "DankLauncher v2 window size. Options: compact, normal, large.";
    };

    dank_launcher_v2_border_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show a border around DankLauncher v2.";
    };

    dank_launcher_v2_border_thickness = lib.mkOption {
      default = 2;
      type = lib.types.int;
      description = "DankLauncher v2 border thickness (pixels).";
    };

    dank_launcher_v2_border_color = lib.mkOption {
      default = "primary";
      type = lib.types.str;
      description = "DankLauncher v2 border color token.";
    };

    dank_launcher_v2_show_footer = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the footer bar in DankLauncher v2.";
    };

    dank_launcher_v2_unload_on_close = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Unload DankLauncher v2 from memory when it is closed.";
    };

    dank_launcher_v2_include_files_in_all = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Include file results in the \"All\" search section.";
    };

    dank_launcher_v2_include_folders_in_all = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Include folder results in the \"All\" search section.";
    };

    launcher_logo_mode = lib.mkOption {
      default = "apps";
      type = lib.types.str;
      description = "Launcher button logo style. Options: apps, custom.";
    };

    launcher_logo_custom_path = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Path to a custom launcher button logo image.";
    };

    launcher_logo_color_override = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Color override for the launcher logo (hex). Empty = theme color.";
    };

    launcher_logo_color_invert_on_mode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Invert the launcher logo color in light mode.";
    };

    launcher_logo_brightness = lib.mkOption {
      default = 0.5;
      type = lib.types.float;
      description = "Launcher logo brightness (0.0–1.0).";
    };

    launcher_logo_contrast = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = "Launcher logo contrast multiplier.";
    };

    launcher_logo_size_offset = lib.mkOption {
      default = 0;
      type = lib.types.int;
      description = "Launcher logo size offset (pixels).";
    };

    # ── Greeter user settings ──────────────────────────────────────────────
    greeter_remember_last_session = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Remember the last selected session in the greeter login screen.";
    };

    greeter_remember_last_user = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Remember the last logged-in user in the greeter.";
    };

    greeter_enable_fprint = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable fingerprint authentication in the greeter.";
    };

    greeter_enable_u2f = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable U2F/FIDO2 authentication in the greeter.";
    };

    greeter_wallpaper_path = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Absolute path to the greeter wallpaper. Empty = system wallpaper.";
    };

    greeter_use24_hour_clock = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Use 24-hour format for the greeter clock.";
    };

    greeter_show_seconds = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show seconds in the greeter clock.";
    };

    greeter_pad_hours12_hour = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Zero-pad hours in 12-hour format on the greeter clock.";
    };

    greeter_lock_date_format = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom Qt date format for the greeter. Empty = locale default.";
    };

    greeter_font_family = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Font family for the greeter UI. Empty = system default.";
    };

    greeter_wallpaper_fill_mode = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Fill mode for the greeter wallpaper. Empty = uses wallpaperFillMode.";
    };

    # ── Cursor ─────────────────────────────────────────────────────────────
    cursor_settings = lib.mkOption {
      default = {
        theme = "System Default";
        size = 24;
        niri = { hideWhenTyping = false; hideAfterInactiveMs = 0; };
        hyprland = { hideOnKeyPress = false; hideOnTouch = false; inactiveTimeout = 0; };
        dwl = { cursorHideTimeout = 0; };
      };
      type = lib.types.anything;
      description = "Cursor theme, size, and compositor-specific hide-on-inactivity settings.";
    };

    # ── Notepad widget ─────────────────────────────────────────────────────
    notepad_use_monospace = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Use a monospace font in the notepad widget.";
    };

    notepad_font_family = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Font family for the notepad widget. Empty = monoFontFamily.";
    };

    notepad_font_size = lib.mkOption {
      default = 14.0;
      type = lib.types.float;
      description = "Font size for the notepad widget (points).";
    };

    notepad_show_line_numbers = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show line numbers in the notepad widget.";
    };

    notepad_transparency_override = lib.mkOption {
      default = (-1.0);
      type = lib.types.float;
      description = "Notepad transparency override (0.0–1.0). -1 = use popupTransparency.";
    };

    notepad_last_custom_transparency = lib.mkOption {
      default = 0.7;
      type = lib.types.float;
      description = "Last manually set notepad transparency (restored on next custom override).";
    };

    # ── Terminal multiplexer ───────────────────────────────────────────────
    mux_type = lib.mkOption {
      default = "tmux";
      type = lib.types.str;
      description = "Terminal multiplexer integration. Options: tmux, zellij.";
    };

    mux_use_custom_command = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Use a custom command to open the multiplexer instead of the built-in integration.";
    };

    mux_custom_command = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command to open the terminal multiplexer.";
    };

    mux_session_filter = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Filter string applied to the multiplexer session list.";
    };

    # ── Launch prefix ──────────────────────────────────────────────────────
    launch_prefix = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Shell prefix prepended to all app launches (e.g. gamemoderun).";
    };

    # ── System updater widget ──────────────────────────────────────────────
    updater_hide_widget = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Hide the system updater widget from the control center.";
    };

    updater_use_custom_command = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Use a custom command for running system updates.";
    };

    updater_custom_command = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Custom shell command for system updates.";
    };

    updater_terminal_additional_params = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Extra parameters passed to the terminal when running updates.";
    };

    # ── Display / multi-monitor ────────────────────────────────────────────
    display_name_mode = lib.mkOption {
      default = "system";
      type = lib.types.str;
      description = "How monitor names are displayed. Options: system, friendly.";
    };

    screen_preferences = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Per-screen display preferences keyed by monitor name.";
    };

    show_on_last_display = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Per-screen setting controlling whether widgets show on the last active display.";
    };

    niri_output_settings = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Niri-specific output configuration per monitor.";
    };

    hyprland_output_settings = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Hyprland-specific output configuration per monitor.";
    };

    display_profiles = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Named display configuration profiles.";
    };

    active_display_profile = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "The currently active display configuration profile.";
    };

    display_profile_auto_select = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Automatically select the best matching display profile on monitor change.";
    };

    display_show_disconnected = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show disconnected monitors in the display settings panel.";
    };

    display_snap_to_edge = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Snap monitors to edges when dragging in the display arrangement UI.";
    };

    # ── Desktop Clock widget ───────────────────────────────────────────────
    desktop_clock_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show a floating clock widget on the desktop wallpaper layer.";
    };

    desktop_clock_style = lib.mkOption {
      default = "analog";
      type = lib.types.str;
      description = "Desktop clock style. Options: analog, digital.";
    };

    desktop_clock_transparency = lib.mkOption {
      default = 0.8;
      type = lib.types.float;
      description = "Desktop clock transparency (0.0–1.0).";
    };

    desktop_clock_color_mode = lib.mkOption {
      default = "primary";
      type = lib.types.str;
      description = "Desktop clock color mode.";
    };

    desktop_clock_custom_color = lib.mkOption {
      default = "#ffffff";
      type = lib.types.str;
      description = "Custom desktop clock color (hex).";
    };

    desktop_clock_show_date = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the date on the desktop clock.";
    };

    desktop_clock_show_analog_numbers = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show hour numerals on the analog desktop clock face.";
    };

    desktop_clock_show_analog_seconds = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the seconds hand on the analog desktop clock.";
    };

    desktop_clock_x = lib.mkOption {
      default = (-1.0);
      type = lib.types.float;
      description = "Desktop clock X position (pixels). -1 = centered.";
    };

    desktop_clock_y = lib.mkOption {
      default = (-1.0);
      type = lib.types.float;
      description = "Desktop clock Y position (pixels). -1 = centered.";
    };

    desktop_clock_width = lib.mkOption {
      default = 280.0;
      type = lib.types.float;
      description = "Desktop clock width (pixels).";
    };

    desktop_clock_height = lib.mkOption {
      default = 180.0;
      type = lib.types.float;
      description = "Desktop clock height (pixels).";
    };

    desktop_clock_display_preferences = lib.mkOption {
      default = [ "all" ];
      type = lib.types.listOf lib.types.str;
      description = "Monitors to show the desktop clock on.";
    };

    # ── System Monitor widget ──────────────────────────────────────────────
    system_monitor_enabled = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show the floating system monitor widget on the desktop.";
    };

    system_monitor_show_header = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show the header row in the system monitor widget.";
    };

    system_monitor_transparency = lib.mkOption {
      default = 0.8;
      type = lib.types.float;
      description = "System monitor widget transparency (0.0–1.0).";
    };

    system_monitor_color_mode = lib.mkOption {
      default = "primary";
      type = lib.types.str;
      description = "System monitor color mode.";
    };

    system_monitor_custom_color = lib.mkOption {
      default = "#ffffff";
      type = lib.types.str;
      description = "Custom system monitor color (hex).";
    };

    system_monitor_show_cpu = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show CPU usage in the system monitor.";
    };

    system_monitor_show_cpu_graph = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show CPU usage history graph in the system monitor.";
    };

    system_monitor_show_cpu_temp = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show CPU temperature in the system monitor.";
    };

    system_monitor_show_gpu_temp = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show GPU temperature in the system monitor.";
    };

    system_monitor_gpu_pci_id = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "PCI ID of the GPU to monitor. Empty = first available GPU.";
    };

    system_monitor_show_memory = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show memory usage in the system monitor.";
    };

    system_monitor_show_memory_graph = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show memory usage history graph in the system monitor.";
    };

    system_monitor_show_network = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show network throughput in the system monitor.";
    };

    system_monitor_show_network_graph = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show network throughput history graph in the system monitor.";
    };

    system_monitor_show_disk = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Show disk usage in the system monitor.";
    };

    system_monitor_show_top_processes = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Show top processes by resource usage in the system monitor.";
    };

    system_monitor_top_process_count = lib.mkOption {
      default = 3;
      type = lib.types.int;
      description = "Number of top processes to display.";
    };

    system_monitor_top_process_sort_by = lib.mkOption {
      default = "cpu";
      type = lib.types.str;
      description = "Sort top processes by. Options: cpu, memory.";
    };

    system_monitor_graph_interval = lib.mkOption {
      default = 60;
      type = lib.types.int;
      description = "History duration shown in system monitor graphs (seconds).";
    };

    system_monitor_layout_mode = lib.mkOption {
      default = "auto";
      type = lib.types.str;
      description = "System monitor layout mode. Options: auto, vertical, horizontal.";
    };

    system_monitor_x = lib.mkOption {
      default = (-1.0);
      type = lib.types.float;
      description = "System monitor X position (pixels). -1 = centered.";
    };

    system_monitor_y = lib.mkOption {
      default = (-1.0);
      type = lib.types.float;
      description = "System monitor Y position (pixels). -1 = centered.";
    };

    system_monitor_width = lib.mkOption {
      default = 320.0;
      type = lib.types.float;
      description = "System monitor width (pixels).";
    };

    system_monitor_height = lib.mkOption {
      default = 480.0;
      type = lib.types.float;
      description = "System monitor height (pixels).";
    };

    system_monitor_display_preferences = lib.mkOption {
      default = [ "all" ];
      type = lib.types.listOf lib.types.str;
      description = "Monitors to show the system monitor widget on.";
    };

    system_monitor_variants = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.anything;
      description = "Additional system monitor widget instances with independent configurations.";
    };

    # ── Desktop widgets ────────────────────────────────────────────────────
    desktop_widget_positions = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Saved positions for desktop plugin widgets per screen.";
    };

    desktop_widget_grid_settings = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Grid layout settings for desktop widgets per screen.";
    };

    desktop_widget_instances = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.anything;
      description = "Desktop widget plugin instances (type, name, config, position).";
    };

    desktop_widget_groups = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.anything;
      description = "Desktop widget group definitions for grouping multiple instances.";
    };

    # ── Misc / clipboard / plugins ─────────────────────────────────────────
    built_in_plugin_settings = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Per-plugin settings for DMS built-in plugins.";
    };

    clipboard_enter_to_paste = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Press Enter to paste the selected clipboard history item.";
    };

    launcher_plugin_visibility = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Per-plugin visibility settings in the launcher (allowWithoutTrigger).";
    };

    launcher_plugin_order = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.str;
      description = "Ordered list of launcher plugin IDs controlling display order.";
    };

    # ── Pinned devices ─────────────────────────────────────────────────────
    brightness_device_pins = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Pinned brightness devices shown at the top of the brightness list.";
    };

    wifi_network_pins = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Pinned WiFi networks shown at the top of the network list.";
    };

    bluetooth_device_pins = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Pinned Bluetooth devices shown at the top of the Bluetooth list.";
    };

    audio_input_device_pins = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Pinned audio input devices shown at the top of the input device list.";
    };

    audio_output_device_pins = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Pinned audio output devices shown at the top of the output device list.";
    };
  };

  config.eiros.system.user_defaults.dms._settings = {
    configVersion = 5;

    currentThemeName = cfg.current_theme_name;
    currentThemeCategory = cfg.current_theme_category;
    customThemeFile = cfg.custom_theme_file;
    registryThemeVariants = cfg.registry_theme_variants;
    matugenScheme = cfg.matugen_scheme;
    matugenContrast = cfg.matugen_contrast;
    runUserMatugenTemplates = cfg.run_user_matugen_templates;
    matugenTargetMonitor = cfg.matugen_target_monitor;

    popupTransparency = cfg.popup_transparency;
    dockTransparency = cfg.dock_transparency;
    widgetBackgroundColor = cfg.widget_background_color;
    widgetColorMode = cfg.widget_color_mode;
    controlCenterTileColorMode = cfg.control_center_tile_color_mode;
    buttonColorMode = cfg.button_color_mode;
    cornerRadius = cfg.corner_radius;

    niriLayoutGapsOverride = cfg.niri_layout_gaps_override;
    niriLayoutRadiusOverride = cfg.niri_layout_radius_override;
    niriLayoutBorderSize = cfg.niri_layout_border_size;
    hyprlandLayoutGapsOverride = cfg.hyprland_layout_gaps_override;
    hyprlandLayoutRadiusOverride = cfg.hyprland_layout_radius_override;
    hyprlandLayoutBorderSize = cfg.hyprland_layout_border_size;
    mangoLayoutGapsOverride = cfg.mango_layout_gaps_override;
    mangoLayoutRadiusOverride = cfg.mango_layout_radius_override;
    mangoLayoutBorderSize = cfg.mango_layout_border_size;

    animationSpeed = cfg.animation_speed;
    customAnimationDuration = cfg.custom_animation_duration;
    syncComponentAnimationSpeeds = cfg.sync_component_animation_speeds;
    popoutAnimationSpeed = cfg.popout_animation_speed;
    popoutCustomAnimationDuration = cfg.popout_custom_animation_duration;
    modalAnimationSpeed = cfg.modal_animation_speed;
    modalCustomAnimationDuration = cfg.modal_custom_animation_duration;
    enableRippleEffects = cfg.enable_ripple_effects;

    m3ElevationEnabled = cfg.m3_elevation_enabled;
    m3ElevationIntensity = cfg.m3_elevation_intensity;
    m3ElevationOpacity = cfg.m3_elevation_opacity;
    m3ElevationColorMode = cfg.m3_elevation_color_mode;
    m3ElevationLightDirection = cfg.m3_elevation_light_direction;
    m3ElevationCustomColor = cfg.m3_elevation_custom_color;
    modalElevationEnabled = cfg.modal_elevation_enabled;
    popoutElevationEnabled = cfg.popout_elevation_enabled;
    barElevationEnabled = cfg.bar_elevation_enabled;

    blurEnabled = cfg.blur_enabled;
    blurBorderColor = cfg.blur_border_color;
    blurBorderCustomColor = cfg.blur_border_custom_color;
    blurBorderOpacity = cfg.blur_border_opacity;
    wallpaperFillMode = cfg.wallpaper_fill_mode;
    blurredWallpaperLayer = cfg.blurred_wallpaper_layer;
    blurWallpaperOnOverview = cfg.blur_wallpaper_on_overview;

    showLauncherButton = cfg.show_launcher_button;
    showWorkspaceSwitcher = cfg.show_workspace_switcher;
    showFocusedWindow = cfg.show_focused_window;
    showWeather = cfg.show_weather;
    showMusic = cfg.show_music;
    showClipboard = cfg.show_clipboard;
    showCpuUsage = cfg.show_cpu_usage;
    showMemUsage = cfg.show_mem_usage;
    showCpuTemp = cfg.show_cpu_temp;
    showGpuTemp = cfg.show_gpu_temp;
    selectedGpuIndex = cfg.selected_gpu_index;
    enabledGpuPciIds = cfg.enabled_gpu_pci_ids;
    showSystemTray = cfg.show_system_tray;
    showClock = cfg.show_clock;
    showNotificationButton = cfg.show_notification_button;
    showBattery = cfg.show_battery;
    showControlCenterButton = cfg.show_control_center_button;
    showCapsLockIndicator = cfg.show_caps_lock_indicator;

    controlCenterShowNetworkIcon = cfg.control_center_show_network_icon;
    controlCenterShowBluetoothIcon = cfg.control_center_show_bluetooth_icon;
    controlCenterShowAudioIcon = cfg.control_center_show_audio_icon;
    controlCenterShowAudioPercent = cfg.control_center_show_audio_percent;
    controlCenterShowVpnIcon = cfg.control_center_show_vpn_icon;
    controlCenterShowBrightnessIcon = cfg.control_center_show_brightness_icon;
    controlCenterShowBrightnessPercent = cfg.control_center_show_brightness_percent;
    controlCenterShowMicIcon = cfg.control_center_show_mic_icon;
    controlCenterShowMicPercent = cfg.control_center_show_mic_percent;
    controlCenterShowBatteryIcon = cfg.control_center_show_battery_icon;
    controlCenterShowPrinterIcon = cfg.control_center_show_printer_icon;
    controlCenterShowScreenSharingIcon = cfg.control_center_show_screen_sharing_icon;
    showPrivacyButton = cfg.show_privacy_button;
    privacyShowMicIcon = cfg.privacy_show_mic_icon;
    privacyShowCameraIcon = cfg.privacy_show_camera_icon;
    privacyShowScreenShareIcon = cfg.privacy_show_screen_share_icon;
    controlCenterWidgets = cfg.control_center_widgets;

    showWorkspaceIndex = cfg.show_workspace_index;
    showWorkspaceName = cfg.show_workspace_name;
    showWorkspacePadding = cfg.show_workspace_padding;
    workspaceScrolling = cfg.workspace_scrolling;
    showWorkspaceApps = cfg.show_workspace_apps;
    workspaceDragReorder = cfg.workspace_drag_reorder;
    maxWorkspaceIcons = cfg.max_workspace_icons;
    workspaceAppIconSizeOffset = cfg.workspace_app_icon_size_offset;
    groupWorkspaceApps = cfg.group_workspace_apps;
    workspaceFollowFocus = cfg.workspace_follow_focus;
    showOccupiedWorkspacesOnly = cfg.show_occupied_workspaces_only;
    reverseScrolling = cfg.reverse_scrolling;
    dwlShowAllTags = cfg.dwl_show_all_tags;
    workspaceActiveAppHighlightEnabled = cfg.workspace_active_app_highlight_enabled;
    workspaceColorMode = cfg.workspace_color_mode;
    workspaceOccupiedColorMode = cfg.workspace_occupied_color_mode;
    workspaceUnfocusedColorMode = cfg.workspace_unfocused_color_mode;
    workspaceUrgentColorMode = cfg.workspace_urgent_color_mode;
    workspaceFocusedBorderEnabled = cfg.workspace_focused_border_enabled;
    workspaceFocusedBorderColor = cfg.workspace_focused_border_color;
    workspaceFocusedBorderThickness = cfg.workspace_focused_border_thickness;
    workspaceNameIcons = cfg.workspace_name_icons;

    waveProgressEnabled = cfg.wave_progress_enabled;
    scrollTitleEnabled = cfg.scroll_title_enabled;
    mediaAdaptiveWidthEnabled = cfg.media_adaptive_width_enabled;
    audioVisualizerEnabled = cfg.audio_visualizer_enabled;
    audioScrollMode = cfg.audio_scroll_mode;
    audioWheelScrollAmount = cfg.audio_wheel_scroll_amount;
    clockCompactMode = cfg.clock_compact_mode;
    focusedWindowCompactMode = cfg.focused_window_compact_mode;
    runningAppsCompactMode = cfg.running_apps_compact_mode;
    barMaxVisibleApps = cfg.bar_max_visible_apps;
    barMaxVisibleRunningApps = cfg.bar_max_visible_running_apps;
    barShowOverflowBadge = cfg.bar_show_overflow_badge;
    appsDockHideIndicators = cfg.apps_dock_hide_indicators;
    appsDockColorizeActive = cfg.apps_dock_colorize_active;
    appsDockActiveColorMode = cfg.apps_dock_active_color_mode;
    appsDockEnlargeOnHover = cfg.apps_dock_enlarge_on_hover;
    appsDockEnlargePercentage = cfg.apps_dock_enlarge_percentage;
    appsDockIconSizePercentage = cfg.apps_dock_icon_size_percentage;
    keyboardLayoutNameCompactMode = cfg.keyboard_layout_name_compact_mode;
    runningAppsCurrentWorkspace = cfg.running_apps_current_workspace;
    runningAppsGroupByApp = cfg.running_apps_group_by_app;
    runningAppsCurrentMonitor = cfg.running_apps_current_monitor;

    appIdSubstitutions = cfg.app_id_substitutions;
    centeringMode = cfg.centering_mode;
    barConfigs = cfg.bar_configs;

    fontFamily = cfg.font_family;
    monoFontFamily = cfg.mono_font_family;
    fontWeight = cfg.font_weight;
    fontScale = cfg.font_scale;

    use24HourClock = cfg.use24_hour_clock;
    showSeconds = cfg.show_seconds;
    padHours12Hour = cfg.pad_hours12_hour;
    clockDateFormat = cfg.clock_date_format;
    lockDateFormat = cfg.lock_date_format;
    firstDayOfWeek = cfg.first_day_of_week;
    showWeekNumber = cfg.show_week_number;
    nightModeEnabled = cfg.night_mode_enabled;

    useFahrenheit = cfg.use_fahrenheit;
    windSpeedUnit = cfg.wind_speed_unit;
    useAutoLocation = cfg.use_auto_location;
    weatherEnabled = cfg.weather_enabled;

    mediaSize = cfg.media_size;

    soundsEnabled = cfg.sounds_enabled;
    useSystemSoundTheme = cfg.use_system_sound_theme;
    soundLogin = cfg.sound_login;
    soundNewNotification = cfg.sound_new_notification;
    soundVolumeChanged = cfg.sound_volume_changed;
    soundPluggedIn = cfg.sound_plugged_in;

    notificationTimeoutLow = cfg.notification_timeout_low;
    notificationTimeoutNormal = cfg.notification_timeout_normal;
    notificationTimeoutCritical = cfg.notification_timeout_critical;
    notificationCompactMode = cfg.notification_compact_mode;
    notificationPopupPosition = cfg.notification_popup_position;
    notificationAnimationSpeed = cfg.notification_animation_speed;
    notificationCustomAnimationDuration = cfg.notification_custom_animation_duration;
    notificationHistoryEnabled = cfg.notification_history_enabled;
    notificationHistoryMaxCount = cfg.notification_history_max_count;
    notificationHistoryMaxAgeDays = cfg.notification_history_max_age_days;
    notificationHistorySaveLow = cfg.notification_history_save_low;
    notificationHistorySaveNormal = cfg.notification_history_save_normal;
    notificationHistorySaveCritical = cfg.notification_history_save_critical;
    notificationRules = cfg.notification_rules;
    notificationFocusedMonitor = cfg.notification_focused_monitor;
    notificationOverlayEnabled = cfg.notification_overlay_enabled;
    notificationPopupShadowEnabled = cfg.notification_popup_shadow_enabled;
    notificationPopupPrivacyMode = cfg.notification_popup_privacy_mode;

    osdAlwaysShowValue = cfg.osd_always_show_value;
    osdPosition = cfg.osd_position;
    osdVolumeEnabled = cfg.osd_volume_enabled;
    osdMediaVolumeEnabled = cfg.osd_media_volume_enabled;
    osdMediaPlaybackEnabled = cfg.osd_media_playback_enabled;
    osdBrightnessEnabled = cfg.osd_brightness_enabled;
    osdIdleInhibitorEnabled = cfg.osd_idle_inhibitor_enabled;
    osdMicMuteEnabled = cfg.osd_mic_mute_enabled;
    osdCapsLockEnabled = cfg.osd_caps_lock_enabled;
    osdPowerProfileEnabled = cfg.osd_power_profile_enabled;
    osdAudioOutputEnabled = cfg.osd_audio_output_enabled;

    lockScreenShowPowerActions = cfg.lock_screen_show_power_actions;
    lockScreenShowSystemIcons = cfg.lock_screen_show_system_icons;
    lockScreenShowTime = cfg.lock_screen_show_time;
    lockScreenShowDate = cfg.lock_screen_show_date;
    lockScreenShowProfileImage = cfg.lock_screen_show_profile_image;
    lockScreenShowPasswordField = cfg.lock_screen_show_password_field;
    lockScreenShowMediaPlayer = cfg.lock_screen_show_media_player;
    lockScreenPowerOffMonitorsOnLock = cfg.lock_screen_power_off_monitors_on_lock;
    lockAtStartup = cfg.lock_at_startup;
    lockScreenActiveMonitor = cfg.lock_screen_active_monitor;
    lockScreenInactiveColor = cfg.lock_screen_inactive_color;
    lockScreenNotificationMode = cfg.lock_screen_notification_mode;
    lockScreenVideoEnabled = cfg.lock_screen_video_enabled;
    lockScreenVideoPath = cfg.lock_screen_video_path;
    lockScreenVideoCycling = cfg.lock_screen_video_cycling;
    fadeToLockEnabled = cfg.fade_to_lock_enabled;
    fadeToLockGracePeriod = cfg.fade_to_lock_grace_period;
    fadeToDpmsEnabled = cfg.fade_to_dpms_enabled;
    fadeToDpmsGracePeriod = cfg.fade_to_dpms_grace_period;
    enableFprint = cfg.enable_fprint;
    maxFprintTries = cfg.max_fprint_tries;
    enableU2f = cfg.enable_u2f;
    u2fMode = cfg.u2f_mode;
    hideBrightnessSlider = cfg.hide_brightness_slider;
    loginctlLockIntegration = cfg.loginctl_lock_integration;
    lockBeforeSuspend = cfg.lock_before_suspend;
    modalDarkenBackground = cfg.modal_darken_background;

    acMonitorTimeout = cfg.ac_monitor_timeout;
    acLockTimeout = cfg.ac_lock_timeout;
    acSuspendTimeout = cfg.ac_suspend_timeout;
    acSuspendBehavior = cfg.ac_suspend_behavior;
    acProfileName = cfg.ac_profile_name;
    acPostLockMonitorTimeout = cfg.ac_post_lock_monitor_timeout;
    batteryMonitorTimeout = cfg.battery_monitor_timeout;
    batteryLockTimeout = cfg.battery_lock_timeout;
    batterySuspendTimeout = cfg.battery_suspend_timeout;
    batterySuspendBehavior = cfg.battery_suspend_behavior;
    batteryProfileName = cfg.battery_profile_name;
    batteryPostLockMonitorTimeout = cfg.battery_post_lock_monitor_timeout;
    batteryChargeLimit = cfg.battery_charge_limit;

    powerActionConfirm = cfg.power_action_confirm;
    powerActionHoldDuration = cfg.power_action_hold_duration;
    powerMenuActions = cfg.power_menu_actions;
    powerMenuDefaultAction = cfg.power_menu_default_action;
    powerMenuGridLayout = cfg.power_menu_grid_layout;
    customPowerActionLock = cfg.custom_power_action_lock;
    customPowerActionLogout = cfg.custom_power_action_logout;
    customPowerActionSuspend = cfg.custom_power_action_suspend;
    customPowerActionHibernate = cfg.custom_power_action_hibernate;
    customPowerActionReboot = cfg.custom_power_action_reboot;
    customPowerActionPowerOff = cfg.custom_power_action_power_off;

    gtkThemingEnabled = cfg.gtk_theming_enabled;
    qtThemingEnabled = cfg.qt_theming_enabled;
    syncModeWithPortal = cfg.sync_mode_with_portal;
    terminalsAlwaysDark = cfg.terminals_always_dark;
    iconTheme = cfg.icon_theme;
    networkPreference = cfg.network_preference;

    runDmsMatugenTemplates = cfg.run_dms_matugen_templates;
    matugenTemplateGtk = cfg.matugen_template_gtk;
    matugenTemplateNiri = cfg.matugen_template_niri;
    matugenTemplateHyprland = cfg.matugen_template_hyprland;
    matugenTemplateMangowc = cfg.matugen_template_mangowc;
    matugenTemplateQt5ct = cfg.matugen_template_qt5ct;
    matugenTemplateQt6ct = cfg.matugen_template_qt6ct;
    matugenTemplateFirefox = cfg.matugen_template_firefox;
    matugenTemplatePywalfox = cfg.matugen_template_pywalfox;
    matugenTemplateZenBrowser = cfg.matugen_template_zen_browser;
    matugenTemplateVesktop = cfg.matugen_template_vesktop;
    matugenTemplateEquibop = cfg.matugen_template_equibop;
    matugenTemplateGhostty = cfg.matugen_template_ghostty;
    matugenTemplateKitty = cfg.matugen_template_kitty;
    matugenTemplateFoot = cfg.matugen_template_foot;
    matugenTemplateAlacritty = cfg.matugen_template_alacritty;
    matugenTemplateNeovim = cfg.matugen_template_neovim;
    matugenTemplateWezterm = cfg.matugen_template_wezterm;
    matugenTemplateDgop = cfg.matugen_template_dgop;
    matugenTemplateKcolorscheme = cfg.matugen_template_kcolorscheme;
    matugenTemplateVscode = cfg.matugen_template_vscode;
    matugenTemplateEmacs = cfg.matugen_template_emacs;
    matugenTemplateZed = cfg.matugen_template_zed;
    matugenTemplateNeovimSettings = cfg.matugen_template_neovim_settings;
    matugenTemplateNeovimSetBackground = cfg.matugen_template_neovim_set_background;

    showDock = cfg.show_dock;
    dockAutoHide = cfg.dock_auto_hide;
    dockSmartAutoHide = cfg.dock_smart_auto_hide;
    dockGroupByApp = cfg.dock_group_by_app;
    dockRestoreSpecialWorkspaceOnClick = cfg.dock_restore_special_workspace_on_click;
    dockOpenOnOverview = cfg.dock_open_on_overview;
    dockPosition = cfg.dock_position;
    dockSpacing = cfg.dock_spacing;
    dockBottomGap = cfg.dock_bottom_gap;
    dockMargin = cfg.dock_margin;
    dockIconSize = cfg.dock_icon_size;
    dockIndicatorStyle = cfg.dock_indicator_style;
    dockBorderEnabled = cfg.dock_border_enabled;
    dockBorderColor = cfg.dock_border_color;
    dockBorderOpacity = cfg.dock_border_opacity;
    dockBorderThickness = cfg.dock_border_thickness;
    dockIsolateDisplays = cfg.dock_isolate_displays;
    dockLauncherEnabled = cfg.dock_launcher_enabled;
    dockLauncherLogoMode = cfg.dock_launcher_logo_mode;
    dockLauncherLogoCustomPath = cfg.dock_launcher_logo_custom_path;
    dockLauncherLogoColorOverride = cfg.dock_launcher_logo_color_override;
    dockLauncherLogoSizeOffset = cfg.dock_launcher_logo_size_offset;
    dockLauncherLogoBrightness = cfg.dock_launcher_logo_brightness;
    dockLauncherLogoContrast = cfg.dock_launcher_logo_contrast;
    dockMaxVisibleApps = cfg.dock_max_visible_apps;
    dockMaxVisibleRunningApps = cfg.dock_max_visible_running_apps;
    dockShowOverflowBadge = cfg.dock_show_overflow_badge;

    appLauncherViewMode = cfg.app_launcher_view_mode;
    spotlightModalViewMode = cfg.spotlight_modal_view_mode;
    browserPickerViewMode = cfg.browser_picker_view_mode;
    browserUsageHistory = cfg.browser_usage_history;
    appPickerViewMode = cfg.app_picker_view_mode;
    filePickerUsageHistory = cfg.file_picker_usage_history;
    sortAppsAlphabetically = cfg.sort_apps_alphabetically;
    appLauncherGridColumns = cfg.app_launcher_grid_columns;
    spotlightCloseNiriOverview = cfg.spotlight_close_niri_overview;
    rememberLastQuery = cfg.remember_last_query;
    spotlightSectionViewModes = cfg.spotlight_section_view_modes;
    appDrawerSectionViewModes = cfg.app_drawer_section_view_modes;
    niriOverviewOverlayEnabled = cfg.niri_overview_overlay_enabled;
    dankLauncherV2Size = cfg.dank_launcher_v2_size;
    dankLauncherV2BorderEnabled = cfg.dank_launcher_v2_border_enabled;
    dankLauncherV2BorderThickness = cfg.dank_launcher_v2_border_thickness;
    dankLauncherV2BorderColor = cfg.dank_launcher_v2_border_color;
    dankLauncherV2ShowFooter = cfg.dank_launcher_v2_show_footer;
    dankLauncherV2UnloadOnClose = cfg.dank_launcher_v2_unload_on_close;
    dankLauncherV2IncludeFilesInAll = cfg.dank_launcher_v2_include_files_in_all;
    dankLauncherV2IncludeFoldersInAll = cfg.dank_launcher_v2_include_folders_in_all;
    launcherLogoMode = cfg.launcher_logo_mode;
    launcherLogoCustomPath = cfg.launcher_logo_custom_path;
    launcherLogoColorOverride = cfg.launcher_logo_color_override;
    launcherLogoColorInvertOnMode = cfg.launcher_logo_color_invert_on_mode;
    launcherLogoBrightness = cfg.launcher_logo_brightness;
    launcherLogoContrast = cfg.launcher_logo_contrast;
    launcherLogoSizeOffset = cfg.launcher_logo_size_offset;

    greeterRememberLastSession = cfg.greeter_remember_last_session;
    greeterRememberLastUser = cfg.greeter_remember_last_user;
    greeterEnableFprint = cfg.greeter_enable_fprint;
    greeterEnableU2f = cfg.greeter_enable_u2f;
    greeterWallpaperPath = cfg.greeter_wallpaper_path;
    greeterUse24HourClock = cfg.greeter_use24_hour_clock;
    greeterShowSeconds = cfg.greeter_show_seconds;
    greeterPadHours12Hour = cfg.greeter_pad_hours12_hour;
    greeterLockDateFormat = cfg.greeter_lock_date_format;
    greeterFontFamily = cfg.greeter_font_family;
    greeterWallpaperFillMode = cfg.greeter_wallpaper_fill_mode;

    cursorSettings = cfg.cursor_settings;

    notepadUseMonospace = cfg.notepad_use_monospace;
    notepadFontFamily = cfg.notepad_font_family;
    notepadFontSize = cfg.notepad_font_size;
    notepadShowLineNumbers = cfg.notepad_show_line_numbers;
    notepadTransparencyOverride = cfg.notepad_transparency_override;
    notepadLastCustomTransparency = cfg.notepad_last_custom_transparency;

    muxType = cfg.mux_type;
    muxUseCustomCommand = cfg.mux_use_custom_command;
    muxCustomCommand = cfg.mux_custom_command;
    muxSessionFilter = cfg.mux_session_filter;

    launchPrefix = cfg.launch_prefix;

    updaterHideWidget = cfg.updater_hide_widget;
    updaterUseCustomCommand = cfg.updater_use_custom_command;
    updaterCustomCommand = cfg.updater_custom_command;
    updaterTerminalAdditionalParams = cfg.updater_terminal_additional_params;

    displayNameMode = cfg.display_name_mode;
    screenPreferences = cfg.screen_preferences;
    showOnLastDisplay = cfg.show_on_last_display;
    niriOutputSettings = cfg.niri_output_settings;
    hyprlandOutputSettings = cfg.hyprland_output_settings;
    displayProfiles = cfg.display_profiles;
    activeDisplayProfile = cfg.active_display_profile;
    displayProfileAutoSelect = cfg.display_profile_auto_select;
    displayShowDisconnected = cfg.display_show_disconnected;
    displaySnapToEdge = cfg.display_snap_to_edge;

    desktopClockEnabled = cfg.desktop_clock_enabled;
    desktopClockStyle = cfg.desktop_clock_style;
    desktopClockTransparency = cfg.desktop_clock_transparency;
    desktopClockColorMode = cfg.desktop_clock_color_mode;
    desktopClockCustomColor = cfg.desktop_clock_custom_color;
    desktopClockShowDate = cfg.desktop_clock_show_date;
    desktopClockShowAnalogNumbers = cfg.desktop_clock_show_analog_numbers;
    desktopClockShowAnalogSeconds = cfg.desktop_clock_show_analog_seconds;
    desktopClockX = cfg.desktop_clock_x;
    desktopClockY = cfg.desktop_clock_y;
    desktopClockWidth = cfg.desktop_clock_width;
    desktopClockHeight = cfg.desktop_clock_height;
    desktopClockDisplayPreferences = cfg.desktop_clock_display_preferences;

    systemMonitorEnabled = cfg.system_monitor_enabled;
    systemMonitorShowHeader = cfg.system_monitor_show_header;
    systemMonitorTransparency = cfg.system_monitor_transparency;
    systemMonitorColorMode = cfg.system_monitor_color_mode;
    systemMonitorCustomColor = cfg.system_monitor_custom_color;
    systemMonitorShowCpu = cfg.system_monitor_show_cpu;
    systemMonitorShowCpuGraph = cfg.system_monitor_show_cpu_graph;
    systemMonitorShowCpuTemp = cfg.system_monitor_show_cpu_temp;
    systemMonitorShowGpuTemp = cfg.system_monitor_show_gpu_temp;
    systemMonitorGpuPciId = cfg.system_monitor_gpu_pci_id;
    systemMonitorShowMemory = cfg.system_monitor_show_memory;
    systemMonitorShowMemoryGraph = cfg.system_monitor_show_memory_graph;
    systemMonitorShowNetwork = cfg.system_monitor_show_network;
    systemMonitorShowNetworkGraph = cfg.system_monitor_show_network_graph;
    systemMonitorShowDisk = cfg.system_monitor_show_disk;
    systemMonitorShowTopProcesses = cfg.system_monitor_show_top_processes;
    systemMonitorTopProcessCount = cfg.system_monitor_top_process_count;
    systemMonitorTopProcessSortBy = cfg.system_monitor_top_process_sort_by;
    systemMonitorGraphInterval = cfg.system_monitor_graph_interval;
    systemMonitorLayoutMode = cfg.system_monitor_layout_mode;
    systemMonitorX = cfg.system_monitor_x;
    systemMonitorY = cfg.system_monitor_y;
    systemMonitorWidth = cfg.system_monitor_width;
    systemMonitorHeight = cfg.system_monitor_height;
    systemMonitorDisplayPreferences = cfg.system_monitor_display_preferences;
    systemMonitorVariants = cfg.system_monitor_variants;

    desktopWidgetPositions = cfg.desktop_widget_positions;
    desktopWidgetGridSettings = cfg.desktop_widget_grid_settings;
    desktopWidgetInstances = cfg.desktop_widget_instances;
    desktopWidgetGroups = cfg.desktop_widget_groups;

    builtInPluginSettings = cfg.built_in_plugin_settings;
    clipboardEnterToPaste = cfg.clipboard_enter_to_paste;
    launcherPluginVisibility = cfg.launcher_plugin_visibility;
    launcherPluginOrder = cfg.launcher_plugin_order;

    brightnessDevicePins = cfg.brightness_device_pins;
    wifiNetworkPins = cfg.wifi_network_pins;
    bluetoothDevicePins = cfg.bluetooth_device_pins;
    audioInputDevicePins = cfg.audio_input_device_pins;
    audioOutputDevicePins = cfg.audio_output_device_pins;
  };
}
