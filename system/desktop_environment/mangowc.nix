{ config, lib, ... }:
let
  eiros_mangowc = config.eiros.system.desktop_environment.mangowc;
in
{
  options.eiros.system.desktop_environment.mangowc = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the Mango Window Composer.";
      type = lib.types.bool;
    };

    add_login_entry = lib.mkOption {
      default = false;
      description = "Add MangoWC to the display manager login session list.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_mangowc.enable {
    programs = {
      mango = {
        enable = true;
        addLoginEntry = eiros_mangowc.add_login_entry;
      };
    };
  };
}
