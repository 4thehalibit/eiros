# Configures Vivaldi browser with hardware video decode flags.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  eiros_vivaldi = config.eiros.system.default_applications.browsers.vivaldi;

  vivaldiFlags =
    [
      "--enable-accelerated-video-decode"
      "--enable-features=VaapiVideoDecoder,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL"
    ]
    ++ eiros_vivaldi.extra_flags;

  vivaldi-wayland = pkgs.vivaldi.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/vivaldi \
        --add-flags "${lib.concatStringsSep " " vivaldiFlags}"
    '';
  });
in
{
  options.eiros.system.default_applications.browsers.vivaldi = {
    extra_flags = lib.mkOption {
      default = [ ];
      description = "Additional command-line flags appended to the Vivaldi wrapper.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.browsers.vivaldi.extra_flags = [ "--force-dark-mode" ];
        }
      '';
      type = lib.types.listOf lib.types.str;
    };

    desktop_file = lib.mkOption {
      default = "vivaldi.desktop";
      description = "Desktop file used for default browser associations.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.browsers.vivaldi.desktop_file = "vivaldi-stable.desktop";
        }
      '';
      type = lib.types.str;
    };

    enable = lib.mkOption {
      default = true;
      description = "Enable Vivaldi as the default browser.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.browsers.vivaldi.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = vivaldi-wayland;
      description = "Vivaldi package to install (wrapped with video decode flags).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.browsers.vivaldi.package = pkgs.vivaldi;
        }
      '';
      type = lib.types.package;
    };
  };

  config = lib.mkIf eiros_vivaldi.enable {
    assertions = [
      {
        assertion = config.nixpkgs.config.allowUnfree or false;
        message = "Vivaldi requires nixpkgs.config.allowUnfree = true.";
      }
    ];

    environment.systemPackages = [
      eiros_vivaldi.package
    ];

    xdg.mime.defaultApplications = {
      "text/html" = [ eiros_vivaldi.desktop_file ];
      "x-scheme-handler/http" = [ eiros_vivaldi.desktop_file ];
      "x-scheme-handler/https" = [ eiros_vivaldi.desktop_file ];
    };
  };
}
