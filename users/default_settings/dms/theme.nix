# DMS theme and matugen color generation options.
{ lib, ... }:
{
  options.eiros.system.user_defaults.dms.theme = {

    current_theme_name = lib.mkOption {
      default = "purple";
      type = lib.types.str;
      description = "Active DMS built-in theme name (e.g. purple, blue, green, red, orange, yellow, pink, grey) or 'custom' to use customThemeFile.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.current_theme_name = "blue";
        }
      '';
    };

    current_theme_category = lib.mkOption {
      default = "auto";
      type = lib.types.str;
      description = "Theme category used for theme registry grouping.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.current_theme_category = "custom";
        }
      '';
    };

    custom_theme_file = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Absolute path to a custom theme JSON file. Only used when currentThemeName = \"custom\".";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.custom_theme_file = "/home/user/.config/dms/my-theme.json";
        }
      '';
    };

    registry_theme_variants = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "Custom theme variant registry entries.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.registry_theme_variants = {
            "my-variant" = { primary = "#6750a4"; };
          };
        }
      '';
    };

    matugen_scheme = lib.mkOption {
      default = "scheme-tonal-spot";
      type = lib.types.str;
      description = "Matugen color generation algorithm. Options: scheme-tonal-spot, scheme-content, scheme-expressive, scheme-fidelity, scheme-fruit-salad, scheme-monochrome, scheme-neutral, scheme-rainbow.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.matugen_scheme = "scheme-expressive";
        }
      '';
    };

    matugen_contrast = lib.mkOption {
      default = 0.0;
      type = lib.types.float;
      description = "Matugen contrast level (-1.0 to 1.0). 0 = default contrast.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.matugen_contrast = 0.3;
        }
      '';
    };

    run_user_matugen_templates = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Run user-defined matugen templates on theme or wallpaper change.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.run_user_matugen_templates = false;
        }
      '';
    };

    matugen_target_monitor = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Monitor to sample wallpaper colors from for matugen. Empty = focused monitor.";
      example = lib.literalExpression ''
        {
          eiros.system.user_defaults.dms.theme.matugen_target_monitor = "HDMI-1";
        }
      '';
    };

  };
}
