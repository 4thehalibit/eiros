# Configures Yazi terminal file manager with opener integration and shell cd-on-exit function.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_yazi = config.eiros.system.default_applications.file_management.yazi;
in
{
  options.eiros.system.default_applications.file_management.yazi = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Yazi file manager.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.yazi.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    default_file_browser.enable = lib.mkOption {
      default = true;
      description = "Use Yazi as the default file browser (terminal-centric).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.yazi.default_file_browser.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    opener = {
      enable = lib.mkOption {
        default = true;
        description = "Enable a sensible default opener for Yazi (installs xdg-utils and configures Yazi to use xdg-open).";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.file_management.yazi.opener.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      package = lib.mkOption {
        default = pkgs.xdg-utils;
        description = "Package providing the opener command (default: xdg-utils for xdg-open).";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.file_management.yazi.opener.package = pkgs.handlr-regex;
          }
        '';
        type = lib.types.package;
      };

      command = lib.mkOption {
        default = "xdg-open";
        description = "Command Yazi should use to open files (e.g. xdg-open).";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.file_management.yazi.opener.command = "handlr open";
          }
        '';
        type = lib.types.str;
      };
    };

    shell_integration.enable = lib.mkOption {
      default = true;
      description = "Add a `y` shell function that opens yazi and cd's to the last directory on exit.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.yazi.shell_integration.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = pkgs.yazi;
      description = "Yazi package to install.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.file_management.yazi.package = pkgs.yazi;
        }
      '';
      type = lib.types.package;
    };
  };

  config = lib.mkIf eiros_yazi.enable {
    environment = {
      systemPackages = lib.optionals eiros_yazi.opener.enable [ eiros_yazi.opener.package ];

      sessionVariables = lib.mkIf eiros_yazi.default_file_browser.enable {
        FILE_MANAGER = "yazi";
        YAZI_FILE_MANAGER = "yazi";
      };

      etc = lib.mkIf eiros_yazi.opener.enable {
        "yazi/yazi.toml".text = ''
          [opener]
          open = [
            { run = "${eiros_yazi.opener.command} \"$@\"", desc = "Open", orphan = true }
          ]

          [open]
          rules = [
            { name = "*", use = "open" }
          ]
        '';
      };
    };

    xdg.mime.defaultApplications = lib.mkIf eiros_yazi.default_file_browser.enable {
      "inode/directory" = "yazi.desktop";
    };

    programs.yazi = {
      enable = true;
      package = eiros_yazi.package;
    };

    programs.zsh.interactiveShellInit = lib.mkIf eiros_yazi.shell_integration.enable ''
      function y() {
        local tmp=$(mktemp -t "yazi-cwd.XXXXXX")
        yazi "$@" --cwd-file="$tmp"
        if cwd=$(cat "$tmp") && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd "$cwd"
        fi
        rm -f "$tmp"
      }
    '';
  };
}
