# Installs Qalculate!, an advanced GTK calculator application.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_qalculate = config.eiros.system.default_applications.utilities.qalculate;
in
{
  options.eiros.system.default_applications.utilities.qalculate = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Qalculate.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.utilities.qalculate.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.qalculate-gtk;
      description = "Qalculate package to install.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.utilities.qalculate.package = pkgs.qalculate-gtk;
        }
      '';
      type = lib.types.package;
    };
  };

  config.environment.systemPackages = lib.mkIf eiros_qalculate.enable [ eiros_qalculate.package ];
}
