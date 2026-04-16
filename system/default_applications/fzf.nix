# Installs fzf fuzzy finder and configures its default command and display options.
{ config, lib, pkgs, ... }:
let
  eiros_fzf = config.eiros.system.default_applications.fzf;
in
{
  options.eiros.system.default_applications.fzf = {
    enable = lib.mkOption {
      default = true;
      description = "Install fzf for interactive fuzzy finding (Ctrl+R history, Ctrl+T file picker).";
      example = false;
      type = lib.types.bool;
    };

    default_command = lib.mkOption {
      default = "fd --type f --hidden --follow --exclude .git";
      description = "Command used by fzf to generate the file list (FZF_DEFAULT_COMMAND).";
      example = "rg --files --hidden";
      type = lib.types.str;
    };

    default_opts = lib.mkOption {
      default = "--preview 'bat --color=always --style=numbers {}'";
      description = "Default fzf options passed to every invocation (FZF_DEFAULT_OPTS).";
      example = "--height 40% --layout=reverse";
      type = lib.types.str;
    };
  };

  config = lib.mkIf eiros_fzf.enable {
    environment.systemPackages = [ pkgs.fzf ];

    environment.variables = {
      FZF_DEFAULT_COMMAND = eiros_fzf.default_command;
      FZF_DEFAULT_OPTS    = eiros_fzf.default_opts;
    };

    programs.zsh.interactiveShellInit = ''
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    '';
  };
}
