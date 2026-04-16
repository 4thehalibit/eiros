# Configures the Plymouth boot splash screen with quiet boot kernel parameters.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_plymouth = config.eiros.system.boot.plymouth;
in
{
  options.eiros.system.boot.plymouth = {
    enable = lib.mkOption {
      default = true;
      description = "Activate the Eiros Plymouth theme";
      example = false;
      type = lib.types.bool;
    };

    kernel_params = lib.mkOption {
      default = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      description = "Kernel parameters applied when quiet boot is enabled.";
      example = [
        "quiet"
        "splash"
      ];
      type = lib.types.listOf lib.types.str;
    };

    loader = {
      timeout = lib.mkOption {
        default = 0;
        description = "Boot loader timeout (seconds) when Plymouth is enabled.";
        example = 5;
        type = lib.types.int;
      };
    };

    quiet_boot = {
      console_log_level = lib.mkOption {
        default = 3;
        description = "Console log level when quiet boot is enabled.";
        example = 0;
        type = lib.types.int;
      };

      enable = lib.mkOption {
        default = true;
        description = "Enable quiet boot settings (kernel params, reduced logging).";
        example = false;
        type = lib.types.bool;
      };

      initrd_verbose = lib.mkOption {
        default = false;
        description = "Whether the initrd should be verbose when quiet boot is enabled.";
        example = true;
        type = lib.types.bool;
      };
    };

    theme = lib.mkOption {
      default = "hud_3";
      description = "Plymouth theme name to use.";
      example = "bgrt";
      type = lib.types.str;
    };

    theme_packages = lib.mkOption {
      default = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "hud_3" ];
        })
      ];
      description = "Packages providing Plymouth themes (added to boot.plymouth.themePackages). Defaults to only the hud_3 theme to minimise initrd closure size.";
      example = lib.literalExpression "[ pkgs.nixos-bgrt-plymouth ]";
      type = lib.types.listOf lib.types.package;
    };
  };

  config = lib.mkIf eiros_plymouth.enable {
    boot = {
      consoleLogLevel = lib.mkIf eiros_plymouth.quiet_boot.enable eiros_plymouth.quiet_boot.console_log_level;

      initrd = {
        verbose = lib.mkIf eiros_plymouth.quiet_boot.enable eiros_plymouth.quiet_boot.initrd_verbose;
      };

      kernelParams = lib.mkIf eiros_plymouth.quiet_boot.enable (
        lib.mkBefore eiros_plymouth.kernel_params
      );

      loader = {
        timeout = eiros_plymouth.loader.timeout;
      };

      plymouth = {
        enable = true;
        theme = eiros_plymouth.theme;
        themePackages = eiros_plymouth.theme_packages;
      };
    };
  };
}
