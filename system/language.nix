{ config, lib, ... }:
let
  eiros_language = config.eiros.system.language;
in
{
  options.eiros.system.language.locale = lib.mkOption {
    default = "en_US.UTF-8";
    description = "Language locale for the system (e.g. en_US.UTF-8).";
    type = lib.types.str;
  };

  config.i18n = {
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
}
