# Installs zoxide, a smart cd replacement that learns your most-used directories.
{ config, lib, pkgs, ... }:
let
  eiros_zoxide = config.eiros.system.default_applications.zoxide;
  eiros_zsh = config.eiros.system.default_applications.zsh;
in
{
  options.eiros.system.default_applications.zoxide = {
    enable = lib.mkOption {
      default = true;
      description = "Install zoxide, a smarter cd that tracks frecency and jumps to directories with z/zi.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.zoxide.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    shell_integration.enable = lib.mkOption {
      default = true;
      description = "Add zoxide shell integration to zsh (enables z, zi, and replaces cd when enabled).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.zoxide.shell_integration.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    replace_cd.enable = lib.mkOption {
      default = false;
      description = "Replace the cd command with zoxide (sets --cmd cd in init).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.zoxide.replace_cd.enable = true;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_zoxide.enable {
    environment.systemPackages = [ pkgs.zoxide ];

    programs.zsh.interactiveShellInit = lib.mkIf (eiros_zoxide.shell_integration.enable && eiros_zsh.enable) ''
      eval "$(zoxide init zsh${lib.optionalString eiros_zoxide.replace_cd.enable " --cmd cd"})"
    '';
  };
}
