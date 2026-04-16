# Configures Fontconfig default font stacks for monospace, sans-serif, serif, and emoji.
{ config, lib, ... }:
let
  eiros_font_config = config.eiros.system.fonts.font_config;
in
{
  options.eiros.system.fonts.font_config = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Fontconfig.";
      example = false;
      type = lib.types.bool;
    };

    default_fonts = {
      monospace = lib.mkOption {
        default = [
          "JetBrainsMono"
          "Noto Sans Mono CJK SC"
          "Noto Sans Mono CJK TC"
          "Noto Sans Mono CJK JP"
          "Noto Sans Mono CJK KR"
        ];
        description = "Default monospace fonts.";
        example = [
          "FiraCode Nerd Font Mono"
          "monospace"
        ];
        type = lib.types.listOf lib.types.str;
      };

      sans_serif = lib.mkOption {
        default = [
          "Inter"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
          "Noto Color Emoji"
        ];
        description = "Default sans-serif fonts.";
        example = [
          "Noto Sans"
          "sans-serif"
        ];
        type = lib.types.listOf lib.types.str;
      };

      serif = lib.mkOption {
        default = [
          "Noto Serif"
          "Noto Serif CJK SC"
          "Noto Serif CJK TC"
          "Noto Serif CJK JP"
          "Noto Serif CJK KR"
        ];
        description = "Default serif fonts.";
        example = [
          "Noto Serif"
          "serif"
        ];
        type = lib.types.listOf lib.types.str;
      };

      emoji = lib.mkOption {
        default = [ "Noto Color Emoji" ];
        description = "Default emoji fonts.";
        example = [ "Noto Color Emoji" ];
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config.fonts.fontconfig = {
    enable = eiros_font_config.enable;

    defaultFonts = {
      monospace = eiros_font_config.default_fonts.monospace;
      sansSerif = eiros_font_config.default_fonts.sans_serif;
      serif = eiros_font_config.default_fonts.serif;
      emoji = eiros_font_config.default_fonts.emoji;
    };
  };
}
