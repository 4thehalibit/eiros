# Installs atuin for enhanced shell history with fuzzy search and optional encrypted sync.
{ config, lib, pkgs, ... }:
let
  eiros_atuin = config.eiros.system.default_applications.atuin;
  eiros_zsh = config.eiros.system.default_applications.zsh;
in
{
  options.eiros.system.default_applications.atuin = {
    enable = lib.mkOption {
      default = true;
      description = "Install atuin for enhanced shell history with fuzzy search (replaces Ctrl+R).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.atuin.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    shell_integration.enable = lib.mkOption {
      default = true;
      description = "Add atuin shell integration to zsh (hooks Ctrl+R and up-arrow history search).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.atuin.shell_integration.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    filter_mode = lib.mkOption {
      default = "global";
      description = "History filter mode: global (all sessions), session (current session), or directory (current directory).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.atuin.filter_mode = "directory";
        }
      '';
      type = lib.types.enum [ "global" "session" "directory" "host" ];
    };

    sync.enable = lib.mkOption {
      default = false;
      description = "Enable atuin sync daemon for encrypted cross-device history synchronisation.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.atuin.sync.enable = true;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_atuin.enable {
    environment.systemPackages = [ pkgs.atuin ];

    environment.etc."atuin/config.toml".text = ''
      filter_mode = "${eiros_atuin.filter_mode}"
      sync_frequency = "${if eiros_atuin.sync.enable then "10m" else "0"}"
    '';

    programs.zsh.interactiveShellInit = lib.mkIf (eiros_atuin.shell_integration.enable && eiros_zsh.enable) ''
      eval "$(atuin init zsh)"
    '';
  };
}
