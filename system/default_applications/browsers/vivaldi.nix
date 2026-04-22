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
      "--disable-features=IntentPicker,DelegatedCompositing,WaylandLinuxDrmSyncobj"

      # --disable-features=WebGPU alone does not stop Dawn from initializing in Vivaldi's build.
      # --disable-blink-features=WebGPU disables the Blink runtime flag, which actually prevents
      # Dawn from being initialized. Without this, Dawn attempts ES 3.1 context creation on every
      # page load (ANGLE GL only exposes ES 3.0), producing eglCreateContext errors and stale
      # SharedImage mailbox accesses that manifest as frame glitches.
      "--disable-blink-features=WebGPU"

      "--enable-zero-copy"
      "--use-cmd-decoder=passthrough"
    ]
    # Use EGL/OpenGL ANGLE backend on NVIDIA (--use-angle=vulkan causes black screens on
    # this NVIDIA+Wayland system). --ignore-gpu-blocklist bypasses the stale NVIDIA WebGL2
    # blocklist entry. VaapiOnNvidiaGPUs activates NVIDIA VA-API (requires libva-nvidia-driver);
    # AcceleratedVideoDecodeLinuxGL and its ZeroCopy variant enable hardware video decode
    # via the GL path with zero-copy buffer handoff.
    ++ lib.optionals eiros_vivaldi.nvidia.enable [
      "--use-angle=gl"
      "--ignore-gpu-blocklist"
      "--enable-features=VaapiOnNvidiaGPUs,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL"
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
