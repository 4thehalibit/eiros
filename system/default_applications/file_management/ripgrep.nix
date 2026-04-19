# Installs ripgrep (rg), a fast recursive regex search tool.
{ config, lib, pkgs, ... }:
let
  eiros_ripgrep = config.eiros.system.default_applications.file_management.ripgrep;
  eiros_zsh = config.eiros.system.default_applications.shells.zsh;
in
{
  options.eiros.system.default_applications.file_management.ripgrep = {
    enable = lib.mkOption {
      default = true;
      description = "Install ripgrep (rg), a fast recursive grep replacement.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.ripgrep.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    override.enable = lib.mkOption {
      default = true;
      description = "Alias grep to rg so ripgrep is used transparently in place of grep.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.ripgrep.override.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_ripgrep.enable {
    environment.systemPackages = [ pkgs.ripgrep ];

    programs.zsh.shellAliases = lib.mkIf (eiros_zsh.enable && eiros_ripgrep.override.enable) {
      grep = "rg";
    };
  };
}
