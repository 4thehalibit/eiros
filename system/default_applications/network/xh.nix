# Installs xh, a fast Rust HTTP client with HTTPie-compatible syntax.
{ config, lib, pkgs, ... }:
let
  eiros_xh = config.eiros.system.default_applications.network.xh;
in
{
  options.eiros.system.default_applications.network.xh.enable = lib.mkOption {
    default = true;
    description = "Install xh, a friendly and fast HTTP client for sending requests (HTTPie-compatible syntax).";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.network.xh.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_xh.enable {
    environment.systemPackages = [ pkgs.xh ];
  };
}
