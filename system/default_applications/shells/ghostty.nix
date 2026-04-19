# Installs the Ghostty terminal emulator.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_ghostty = config.eiros.system.default_applications.shells.ghostty;
in
{
  options.eiros.system.default_applications.shells.ghostty = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Ghostty terminal";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.ghostty.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.ghostty;
      description = "Ghostty package to install.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.ghostty.package = pkgs.ghostty;
        }
      '';
      type = lib.types.package;
    };
  };

  config.environment.systemPackages = lib.mkIf eiros_ghostty.enable [ eiros_ghostty.package ];
}
