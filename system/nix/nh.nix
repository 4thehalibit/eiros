# Installs nh, a Nix helper that wraps nixos-rebuild with nicer output and
# automatic store cleaning. Set nh.flake to your config path so commands like
# `nh os switch` work without specifying --flake each time.
{ config, lib, ... }:
let
  eiros_nh = config.eiros.system.nix.nh;
in
{
  options.eiros.system.nix.nh = {
    enable = lib.mkOption {
      default = true;
      description = "Install nh, a Nix helper wrapping nixos-rebuild with better output and automatic cleaning.";
      example = lib.literalExpression ''
        {
          eiros.system.nix.nh.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    flake = lib.mkOption {
      default = null;
      description = "Path to the NixOS configuration flake. Sets NH_FLAKE so commands like `nh os switch` work without specifying --flake each time.";
      example = lib.literalExpression ''
        {
          eiros.system.nix.nh.flake = "/home/user/Documents/eiros";
        }
      '';
      type = lib.types.nullOr lib.types.str;
    };

    clean = {
      enable = lib.mkOption {
        default = true;
        description = "Enable automatic store cleaning via `nh clean all` on a timer.";
        example = lib.literalExpression ''
          {
            eiros.system.nix.nh.clean.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      dates = lib.mkOption {
        default = "daily";
        description = "systemd OnCalendar schedule for `nh clean all`.";
        example = lib.literalExpression ''
          {
            eiros.system.nix.nh.clean.dates = "daily";
          }
        '';
        type = lib.types.str;
      };

      extra_args = lib.mkOption {
        default = "";
        description = "Extra arguments passed to `nh clean all` (e.g. \"--keep 5 --keep-since 5d\").";
        example = lib.literalExpression ''
          {
            eiros.system.nix.nh.clean.extra_args = "--keep 5 --keep-since 5d";
          }
        '';
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf eiros_nh.enable {
    programs.nh = {
      enable = true;
      flake = eiros_nh.flake;
      clean = {
        enable = eiros_nh.clean.enable;
        dates = eiros_nh.clean.dates;
        extraArgs = eiros_nh.clean.extra_args;
      };
    };
  };
}
