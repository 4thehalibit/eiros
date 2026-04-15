{ config, lib, pkgs, ... }:
let
  eiros_fzf = config.eiros.system.default_applications.fzf;
in
{
  options.eiros.system.default_applications.fzf = {
    enable = lib.mkOption {
      default = true;
      description = "Install fzf for interactive fuzzy finding (Ctrl+R history, Ctrl+T file picker).";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_fzf.enable {
    environment.systemPackages = [ pkgs.fzf ];

    environment.variables = {
      FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
      FZF_DEFAULT_OPTS    = "--preview 'bat --color=always --style=numbers {}'";
    };

    programs.zsh.interactiveShellInit = ''
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    '';
  };
}
