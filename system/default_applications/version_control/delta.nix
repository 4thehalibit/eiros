# Installs delta as a syntax-highlighted, side-by-side diff pager for git.
{ config, lib, pkgs, ... }:
let
  eiros_delta = config.eiros.system.default_applications.version_control.delta;
  eiros_git = config.eiros.system.default_applications.version_control.git;
in
{
  options.eiros.system.default_applications.version_control.delta = {
    enable = lib.mkOption {
      default = true;
      description = "Install delta and configure it as the git diff pager.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.version_control.delta.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    side_by_side.enable = lib.mkOption {
      default = true;
      description = "Show diffs in side-by-side mode.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.version_control.delta.side_by_side.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    navigate.enable = lib.mkOption {
      default = true;
      description = "Enable n/N keybinds to jump between diff sections.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.version_control.delta.navigate.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    line_numbers.enable = lib.mkOption {
      default = true;
      description = "Show line numbers in the diff output.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.version_control.delta.line_numbers.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (eiros_delta.enable && eiros_git.enable) {
    environment.systemPackages = [ pkgs.delta ];

    programs.git.config = [{
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = eiros_delta.navigate.enable;
        side-by-side = eiros_delta.side_by_side.enable;
        line-numbers = eiros_delta.line_numbers.enable;
      };
      merge.conflictstyle = "zdiff3";
    }];
  };
}
