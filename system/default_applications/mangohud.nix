# Enables MangoHUD, an in-game performance overlay for Vulkan and OpenGL applications.
{ config, lib, ... }:
let
  eiros_mangohud = config.eiros.system.default_applications.mangohud;
  eiros_gamemode = config.eiros.system.default_applications.gamemode;
in
{
  options.eiros.system.default_applications.mangohud.enable = lib.mkOption {
    default = true;
    description = "Enable MangoHUD performance overlay. Activates when MANGOHUD=1 is set; has zero runtime cost otherwise. Pairs naturally with GameMode.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.mangohud.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_mangohud.enable {
    warnings = lib.optionals (!eiros_gamemode.enable) [
      "MangoHUD is enabled but GameMode is disabled. MangoHUD will still work, but pairing it with GameMode (eiros.system.default_applications.gamemode.enable = true) gives better performance profiling."
    ];

    programs.mangohud.enable = true;
  };
}
