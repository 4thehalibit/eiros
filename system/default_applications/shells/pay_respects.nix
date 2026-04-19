# Installs pay-respects, a shell command corrector that fixes mistyped commands.
{ config, lib, pkgs, ... }:
let
  eiros_pay_respects = config.eiros.system.default_applications.shells.pay_respects;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.shells.pay_respects = {
    enable = lib.mkOption {
      default = true;
      description = "Install pay-respects to correct mistyped shell commands (type the alias after a failed command to fix it).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.pay_respects.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    alias = lib.mkOption {
      default = "f";
      description = "Shell alias used to invoke the command corrector.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.shells.pay_respects.alias = "fuck";
        }
      '';
      type = lib.types.str;
    };
  };

  config = lib.mkIf eiros_pay_respects.enable {
    environment.systemPackages = [ pkgs.pay-respects ];

    programs.zsh.interactiveShellInit = lib.mkIf eiros_zsh.enable ''
      eval "$(pay-respects zsh --alias ${eiros_pay_respects.alias})"
    '';
  };
}
