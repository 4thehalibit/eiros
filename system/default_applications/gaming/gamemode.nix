# Enables GameMode for on-demand CPU performance profiling of games and latency-sensitive apps.
{ config, lib, ... }:
let
  eiros_gamemode = config.eiros.system.default_applications.gaming.gamemode;
in
{
  options.eiros.system.default_applications.gaming.gamemode.enable = lib.mkOption {
    default = true;
    description = "Enable GameMode for on-demand CPU performance profiles. Any latency-sensitive application can request a performance boost via the GameMode D-Bus API.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.gaming.gamemode.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_gamemode.enable {
    programs.gamemode.enable = true;
  };
}
