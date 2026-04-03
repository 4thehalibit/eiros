{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_graphics = config.eiros.system.hardware.graphics;
  eiros_nvidia = eiros_graphics.nvidia;

  nvidia_enabled = eiros_graphics.enable && eiros_nvidia.enable;

  prime_enabled = nvidia_enabled && eiros_nvidia.prime.enable;
  prime_offload_enabled = prime_enabled && eiros_nvidia.prime.offload.enable;
  prime_sync_enabled = prime_enabled && eiros_nvidia.prime.sync.enable;
in
{
  options.eiros.system.hardware.graphics = {
    enable = lib.mkOption {
      default = true;
      description = "Enable Eiros hardware graphics.";
      type = lib.types.bool;
    };

    enable_32_bit = lib.mkOption {
      default = true;
      description = "Enable 32-bit graphics libraries (for 32-bit applications).";
      type = lib.types.bool;
    };

    nvidia = {
      enable = lib.mkOption {
        default = true;
        description = "Enable NVIDIA GPU support.";
        type = lib.types.bool;
      };

      enable_container_toolkit = lib.mkOption {
        default = true;
        description = "Enable NVIDIA Container Toolkit (for GPU support in containers).";
        type = lib.types.bool;
      };

      open.enable = lib.mkOption {
        default = true;
        description = "Enable the NVIDIA open kernel module (hardware.nvidia.open).";
        type = lib.types.bool;
      };

      enable_nvidia_settings = lib.mkOption {
        default = true;
        description = "Install the nvidia-settings GUI tool.";
        type = lib.types.bool;
      };

      prime = {
        enable = lib.mkOption {
          default = false;
          description = "Enable NVIDIA PRIME (hybrid graphics) configuration.";
          type = lib.types.bool;
        };

        intel_bus_id = lib.mkOption {
          default = null;
          description = "Intel iGPU PCI Bus ID (e.g. \"PCI:0:2:0\"). Required when PRIME is enabled.";
          type = lib.types.nullOr lib.types.str;
        };

        nvidia_bus_id = lib.mkOption {
          default = null;
          description = "NVIDIA dGPU PCI Bus ID (e.g. \"PCI:1:0:0\"). Required when PRIME is enabled.";
          type = lib.types.nullOr lib.types.str;
        };

        offload.enable = lib.mkOption {
          default = true;
          description = "Enable PRIME render offload (recommended default for laptops).";
          type = lib.types.bool;
        };

        sync.enable = lib.mkOption {
          default = false;
          description = "Enable PRIME sync (use instead of offload).";
          type = lib.types.bool;
        };
      };

      wayland = {
        wlr_no_hardware_cursors.enable = lib.mkOption {
          default = true;
          description = "Set WLR_NO_HARDWARE_CURSORS=1 (wlroots cursor workaround).";
          type = lib.types.bool;
        };
      };
    };
  };

  config = lib.mkIf eiros_graphics.enable {
    assertions = [
      {
        assertion = !nvidia_enabled || (config.nixpkgs.config.allowUnfree or false);
        message = "NVIDIA support is enabled, but nixpkgs.config.allowUnfree is false; NVIDIA drivers may be unavailable.";
      }
      {
        assertion =
          !prime_enabled
          || (eiros_nvidia.prime.intel_bus_id != null && eiros_nvidia.prime.nvidia_bus_id != null);
        message = "NVIDIA PRIME is enabled; set eiros.system.hardware.graphics.nvidia.prime.intel_bus_id and .nvidia_bus_id.";
      }
      {
        assertion = !(prime_offload_enabled && prime_sync_enabled);
        message = "NVIDIA PRIME: offload and sync cannot both be enabled; choose one.";
      }
    ];

    environment = {
      variables = lib.mkIf nvidia_enabled (
        {
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        }
        // (lib.optionalAttrs eiros_nvidia.wayland.wlr_no_hardware_cursors.enable {
          WLR_NO_HARDWARE_CURSORS = "1";
        })
      );
    };

    hardware = {
      graphics = {
        enable = true;

        enable32Bit = eiros_graphics.enable_32_bit;

        extraPackages = lib.optionals nvidia_enabled [
          pkgs.egl-wayland
          pkgs.nvidia-vaapi-driver
        ];
      };

      nvidia = lib.mkIf nvidia_enabled (
        {
          modesetting = {
            enable = true;
          };

          nvidiaSettings = eiros_nvidia.enable_nvidia_settings;
          open = eiros_nvidia.open.enable;
        }
        // (lib.optionalAttrs prime_enabled {
          prime = {
            intelBusId = eiros_nvidia.prime.intel_bus_id;
            nvidiaBusId = eiros_nvidia.prime.nvidia_bus_id;

            offload = {
              enable = eiros_nvidia.prime.offload.enable;
              enableOffloadCmd = eiros_nvidia.prime.offload.enable;
            };

            sync = {
              enable = eiros_nvidia.prime.sync.enable;
            };
          };
        })
      );

      nvidia-container-toolkit = lib.mkIf (nvidia_enabled && eiros_nvidia.enable_container_toolkit) {
        enable = true;
      };
    };

    services = {
      xserver = {
        videoDrivers = lib.mkIf nvidia_enabled [ "nvidia" ];
      };
    };
  };
}
