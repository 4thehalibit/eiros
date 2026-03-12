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
        type = lib.types.listOf lib.types.package;
      };

      cjk = lib.mkOption {
        default = with pkgs; [
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];
        description = "CJK font packages.";
        type = lib.types.listOf lib.types.package;
      };
    };
  };

  config = lib.mkIf eiros_fonts.enable {
    fonts.packages = eiros_fonts.packages.base ++ eiros_fonts.packages.cjk;
  };
}
