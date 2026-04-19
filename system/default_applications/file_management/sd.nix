# Installs sd, an intuitive find-and-replace CLI (sed alternative) written in Rust.
{ config, lib, pkgs, ... }:
let
  eiros_sd = config.eiros.system.default_applications.file_management.sd;
in
{
  options.eiros.system.default_applications.file_management.sd.enable = lib.mkOption {
    default = true;
    description = "Install sd, a simple and fast find-and-replace tool (sed alternative).";
    example = lib.literalExpression ''
      {
        eiros.system.default_applications.file_management.sd.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_sd.enable {
    environment.systemPackages = [ pkgs.sd ];
  };
}
