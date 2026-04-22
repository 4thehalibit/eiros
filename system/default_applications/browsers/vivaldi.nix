# Configures Vivaldi browser with Wayland/Ozone flags and optional NVIDIA/EGL ANGLE support.
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
      "--ozone-platform=wayland"

      "--enable-features=UseOzonePlatform,ExternalProtocolDialog"
      "--disable-features=IntentPicker,DelegatedCompositing"

      "--disable-zero-copy"
      "--num-raster-threads=1"
    ]
    # Use EGL/OpenGL ANGLE backend on NVIDIA. The Vulkan ANGLE path fails to import
    # Wayland compositor DMA-BUFs on hybrid AMD+NVIDIA systems: the compositor (running
    # on the AMD display GPU) allocates buffers with AMD format modifiers that NVIDIA
    # Vulkan rejects (VK_ERROR_FEATURE_NOT_PRESENT in DmaBufImageSiblingVkLinux:616).
    # EGL handles cross-driver modifier negotiation more permissively. NVIDIA GL 4.6
    # covers all WebGL2 requirements; --ignore-gpu-blocklist bypasses stale blocklist entries.
    ++ lib.optionals eiros_vivaldi.nvidia.enable [
      "--use-angle=gl"
      "--ignore-gpu-blocklist"
    ]
    ++ lib.optionals (eiros_vivaldi.nvidia.enable && eiros_vivaldi.gpu_sandbox.disable) [
      "--disable-gpu-sandbox"
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
    nvidia = {
      enable = lib.mkOption {
        default = false;
        description = "Enable NVIDIA-specific flags (--use-angle=gl, --ignore-gpu-blocklist). Defaults to eiros.system.hardware.graphics.nvidia.enable. Required for WebGL2 on NVIDIA/Wayland.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.browsers.vivaldi.nvidia.enable = true;
          }
        '';
        type = lib.types.bool;
      };
    };

    gpu_sandbox = {
      disable = lib.mkOption {
        default = true;
        description = "Disable Chromium's GPU process sandbox (--disable-gpu-sandbox). Only takes effect when nvidia.enable = true. May be required for EGL/ANGLE on NVIDIA/Wayland.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.browsers.vivaldi.gpu_sandbox.disable = true;
          }
        '';
        type = lib.types.bool;
      };
    };

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
      description = "Vivaldi package to install (Wayland/Ozone wrapped).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.browsers.vivaldi.package = pkgs.vivaldi;
        }
      '';
      type = lib.types.package;
    };
  };

  config = lib.mkMerge [
    {
      eiros.system.default_applications.browsers.vivaldi.nvidia.enable = lib.mkDefault (
        config.eiros.system.hardware.graphics.nvidia.enable or false
      );
    }

    (lib.mkIf eiros_vivaldi.enable {
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
    })
  ];
}
