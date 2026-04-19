# DMS font, clock & date, weather, media player, and sound options.
{ lib, ... }:
{
  options.eiros.system.user_defaults.dms = {

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
      default = true;
      type = lib.types.bool;
      description = "Display temperatures in Fahrenheit (default: Celsius).";
    };

    wind_speed_unit = lib.mkOption {
      default = "mph";
      type = lib.types.str;
      description = "Wind speed unit. Options: kmh, mph, ms, kn.";
    };

    use_auto_location = lib.mkOption {
      default = true;
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

  };
}
