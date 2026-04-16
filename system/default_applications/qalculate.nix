# Installs Qalculate!, an advanced GTK calculator application.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_qalculate = config.eiros.system.default_applications.qalculate;
in
{
  options.eiros.system.default_applications.qalculate = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Qalculate.";
      example = false;
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.qalculate-gtk;
      description = "Qalculate package to install.";
      example = lib.literalExpression "pkgs.qalculate-gtk";
      type = lib.types.package;
    };
  };

  config.environment.systemPackages = lib.mkIf eiros_qalculate.enable [ eiros_qalculate.package ];
}
