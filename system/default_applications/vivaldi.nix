{
  config,
  lib,
  pkgs,
  ...
}:

let
  eiros_vivaldi = config.eiros.system.default_applications.vivaldi;

  vivaldiFlags =
    [
      "--ozone-platform=wayland"

      "--enable-features=UseOzonePlatform,ExternalProtocolDialog"
      "--disable-features=IntentPicker,DelegatedCompositing,WaylandLinuxDrmSyncobj"
    ]
    # Disables Chromium's GPU process sandbox. This is a security regression but
    # may be required to work around rendering issues with certain NVIDIA driver
    # and Vulkan combinations. Opt-in via disable_gpu_sandbox = true.
    ++ lib.optionals eiros_vivaldi.disable_gpu_sandbox [ "--disable-gpu-sandbox" ]
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
  options.eiros.system.default_applications.vivaldi = {
    disable_gpu_sandbox = lib.mkOption {
      default = false;
      description = "Disable Chromium's GPU process sandbox (--disable-gpu-sandbox). This is a security regression — only enable if needed to work around NVIDIA/Vulkan rendering issues.";
      type = lib.types.bool;
    };

    extra_flags = lib.mkOption {
      default = [ ];
      description = "Additional command-line flags appended to the Vivaldi wrapper.";
      type = lib.types.listOf lib.types.str;
    };

    desktop_file = lib.mkOption {
      default = "vivaldi.desktop";
      description = "Desktop file used for default browser associations.";
      type = lib.types.str;
    };

    enable = lib.mkOption {
      default = true;
      description = "Enable Vivaldi as the default browser.";
      type = lib.types.bool;
    };

    package = lib.mkOption {
      default = vivaldi-wayland;
      description = "Vivaldi package to install (Wayland/Ozone wrapped).";
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
