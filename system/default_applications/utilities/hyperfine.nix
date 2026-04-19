# Installs hyperfine, a command-line benchmarking tool with statistical analysis.
{ config, lib, pkgs, ... }:
let
  eiros_hyperfine = config.eiros.system.default_applications.utilities.hyperfine;
in
{
  options.eiros.system.default_applications.utilities.hyperfine.enable = lib.mkOption {
    default = true;
    description = "Install hyperfine, a command-line benchmarking tool with statistical output and export support.";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.utilities.hyperfine.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_hyperfine.enable {
    environment.systemPackages = [ pkgs.hyperfine ];
  };
}
