# Configures the system locale and sets all LC_ categories to a consistent value.
{ config, lib, ... }:
let
  eiros_language = config.eiros.system.locale.language;
in
{
  options.eiros.system.locale.language = {
    enable = lib.mkOption {
      default = true;
      description = "Configure system locale and i18n settings.";
      example = lib.literalExpression ''
        {
          eiros.system.locale.language.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    locale = lib.mkOption {
      default = "en_US.UTF-8";
      description = "Language locale for the system (e.g. en_US.UTF-8).";
      example = lib.literalExpression ''
        {
          eiros.system.locale.language.locale = "en_GB.UTF-8";
        }
      '';
      type = lib.types.str;
    };
  };

  config = lib.mkIf eiros_language.enable {
    i18n = {
      defaultLocale = eiros_language.locale;

      extraLocaleSettings = builtins.listToAttrs (
        map (key: { name = key; value = eiros_language.locale; }) [
          "LC_ADDRESS"
          "LC_COLLATE"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ]
      );
    };
  };
}
