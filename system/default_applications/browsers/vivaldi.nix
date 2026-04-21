# Configures Vivaldi browser with Wayland/Ozone flags and optional NVIDIA/Vulkan ANGLE support.
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
      "--disable-features=IntentPicker,DelegatedCompositing,WaylandLinuxDrmSyncobj"

      "--disable-zero-copy"
      "--num-raster-threads=1"
    ]
    ++ lib.optionals eiros_vivaldi.nvidia.enable [
      "--use-angle=vulkan"
      "--ignore-gpu-blocklist"
    ]
    # Vivaldi internally sets --render-node-override=renderD128 (AMD iGPU on this system).
    # Override it to the NVIDIA render node so GBM allocates DMA-BUFs on NVIDIA, making
    # them importable by ANGLE's NVIDIA Vulkan backend (avoids VK_ERROR_FEATURE_NOT_PRESENT).
    # /dev/dri/nvidia-render is a udev-managed stable symlink (see services.udev.extraRules).
    ++ lib.optionals (eiros_vivaldi.nvidia.enable && eiros_vivaldi.render_node.auto_detect) [
      "--render-node-override=/dev/dri/nvidia-render"
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
        description = "Enable NVIDIA-specific flags (--use-angle=vulkan, --ignore-gpu-blocklist) and render node override. Defaults to eiros.system.hardware.graphics.nvidia.enable. Required for WebGL2 on NVIDIA/Wayland with Vulkan ANGLE.";
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
        description = "Disable Chromium's GPU process sandbox (--disable-gpu-sandbox). Only takes effect when nvidia.enable = true. Required for Vulkan ANGLE on NVIDIA/Wayland — the Vulkan driver needs unrestricted access to GPU devices.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.browsers.vivaldi.gpu_sandbox.disable = true;
          }
        '';
        type = lib.types.bool;
      };
    };

    render_node = {
      auto_detect = lib.mkOption {
        default = true;
        description = "When nvidia.enable is true, create a udev rule that makes /dev/dri/nvidia-render a stable symlink to the NVIDIA GPU render node (matched by PCI vendor 0x10de), and pass it as --render-node-override. This overrides Vivaldi's internal AMD render node selection, fixing cross-GPU DMA-BUF import failures under Vulkan ANGLE. Disable to manage via extra_flags.";
        example = lib.literalExpression ''
          {
            eiros.system.default_applications.browsers.vivaldi.render_node.auto_detect = false;
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

      # Creates /dev/dri/nvidia-render as a stable udev symlink to the NVIDIA render node.
      # Matched by PCI vendor ID 0x10de; survives PCI enumeration order changes.
      services.udev.extraRules = lib.mkIf (eiros_vivaldi.nvidia.enable && eiros_vivaldi.render_node.auto_detect) ''
        SUBSYSTEM=="drm", KERNEL=="renderD*", ATTRS{vendor}=="0x10de", SYMLINK+="dri/nvidia-render"
      '';

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
