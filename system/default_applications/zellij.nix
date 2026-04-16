# Installs Zellij terminal multiplexer with optional shell auto-attach integration.
{ config, lib, pkgs, ... }:
let
  eiros_zellij = config.eiros.system.default_applications.zellij;
  eiros_zsh = config.eiros.system.default_applications.zsh;
in
{
  options.eiros.system.default_applications.zellij = {
    enable = lib.mkOption {
      default = false;
      description = "Install Zellij terminal multiplexer.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.zellij.enable = true;
        }
      '';
      type = lib.types.bool;
    };

    auto_attach.enable = lib.mkOption {
      default = false;
      description = "Automatically attach to (or create) a Zellij session when opening a terminal.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.zellij.auto_attach.enable = true;
        }
      '';
      type = lib.types.bool;
    };

    auto_exit.enable = lib.mkOption {
      default = false;
      description = "Exit the shell when detaching from a Zellij session (only applies when auto_attach is enabled).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.zellij.auto_exit.enable = true;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_zellij.enable {
    environment.systemPackages = [ pkgs.zellij ];

    programs.zsh.interactiveShellInit = lib.mkIf (eiros_zellij.auto_attach.enable && eiros_zsh.enable) ''
      if [[ -z "$ZELLIJ" ]]; then
        if zellij list-sessions 2>/dev/null | grep -q .; then
          zellij attach
        else
          zellij
        fi
        ${lib.optionalString eiros_zellij.auto_exit.enable "exit"}
      fi
    '';
  };
}
