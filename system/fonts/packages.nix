# Installs base, CJK, and Nerd Font packages used by terminal prompts and UI applications.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_fonts = config.eiros.system.fonts.packages;
in
{
  options.eiros.system.fonts.packages = {
    enable = lib.mkOption {
      default = true;
      description = "Enable font package installation.";
      example = false;
      type = lib.types.bool;
    };

    packages = {
      base = lib.mkOption {
        default = with pkgs; [
          inter
          jetbrains-mono
          noto-fonts
          noto-fonts-color-emoji
        ];
        description = "Base font packages.";
        example = lib.literalExpression "[ pkgs.noto-fonts pkgs.inter ]";
        type = lib.types.listOf lib.types.package;
      };

      cjk = lib.mkOption {
        default = with pkgs; [
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];
        description = "CJK font packages.";
        example = lib.literalExpression "[ pkgs.noto-fonts-cjk-sans ]";
        type = lib.types.listOf lib.types.package;
      };

      nerd = lib.mkOption {
        default = [ pkgs.nerd-fonts.jetbrains-mono ];
        description = "Nerd Font packages. Provides glyph icons used by terminal prompts (e.g. spaceship) and tools like eza.";
        example = lib.literalExpression "[ pkgs.nerd-fonts.fira-code ]";
        type = lib.types.listOf lib.types.package;
      };
    };
  };

  config = lib.mkIf eiros_fonts.enable {
    fonts.packages =
      eiros_fonts.packages.base
      ++ eiros_fonts.packages.cjk
      ++ eiros_fonts.packages.nerd;
  };
}
