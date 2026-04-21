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
    ++ lib.optionals (eiros_vivaldi.nvidia.enable && eiros_vivaldi.gpu_sandbox.disable) [
      "--disable-gpu-sandbox"
    ]
    ++ eiros_vivaldi.extra_flags;

  vivaldi-wayland = pkgs.vivaldi.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

    postFixup =
      (old.postFixup or "")
      + ''
        wrapProgram $out/bin/vivaldi \
          --add-flags "${lib.concatStringsSep " " vivaldiFlags}"
      ''
      + lib.optionalString (eiros_vivaldi.nvidia.enable && eiros_vivaldi.render_node.auto_detect) ''
        mv $out/bin/vivaldi $out/bin/.vivaldi-static
        cat > $out/bin/vivaldi << 'ENDSCRIPT'
#!/bin/sh
RENDER_FLAG=
for node in /dev/dri/renderD*; do
  devname=$(basename "$node")
  vendor=$(cat /sys/class/drm/"$devname"/device/vendor 2>/dev/null || true)
  if [ "$vendor" = "0x10de" ]; then
    RENDER_FLAG="--render-node-override=$node"
    break
  fi
done
ENDSCRIPT
        echo "exec $out/bin/.vivaldi-static \$RENDER_FLAG \"\$@\"" >> $out/bin/vivaldi
        chmod +x $out/bin/vivaldi
      '';
  });
in
{
  options.eiros.system.default_applications.browsers.vivaldi = {
    nvidia = {
      enable = lib.mkOption {
        default = false;
        description = "Enable NVIDIA-specific flags (--use-angle=vulkan, --ignore-gpu-blocklist) and render node auto-detection. Defaults to eiros.system.hardware.graphics.nvidia.enable. Required for WebGL2 on NVIDIA/Wayland with Vulkan ANGLE.";
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
        description = "When nvidia.enable is true, auto-detect the NVIDIA GPU render node by PCI vendor ID (0x10de) at Vivaldi launch time and pass as --render-node-override. Overrides Vivaldi's internal AMD render node selection. Disable to manage via extra_flags.";
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
