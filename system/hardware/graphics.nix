# Configures NVIDIA/Mesa GPU drivers, 32-bit support, and PRIME hybrid graphics.
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
      example = lib.literalExpression ''
        {
          eiros.system.hardware.graphics.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    bits_32 = {
      enable = lib.mkOption {
        default = true;
        description = "Enable 32-bit graphics libraries (for 32-bit applications).";
        example = lib.literalExpression ''
          {
            eiros.system.hardware.graphics.bits_32.enable = false;
          }
        '';
        type = lib.types.bool;
      };
    };

    nvidia = {
      enable = lib.mkOption {
        default = true;
        description = "Enable NVIDIA GPU support.";
        example = lib.literalExpression ''
          {
            eiros.system.hardware.graphics.nvidia.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      container_toolkit = {
        enable = lib.mkOption {
          default = true;
          description = "Enable NVIDIA Container Toolkit (for GPU support in containers).";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.container_toolkit.enable = false;
            }
          '';
          type = lib.types.bool;
        };
      };

      open.enable = lib.mkOption {
        default = true;
        description = "Enable the NVIDIA open kernel module (hardware.nvidia.open).";
        example = lib.literalExpression ''
          {
            eiros.system.hardware.graphics.nvidia.open.enable = false;
          }
        '';
        type = lib.types.bool;
      };

      settings = {
        enable = lib.mkOption {
          default = true;
          description = "Install the nvidia-settings GUI tool.";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.settings.enable = false;
            }
          '';
          type = lib.types.bool;
        };
      };

      prime = {
        enable = lib.mkOption {
          default = false;
          description = "Enable NVIDIA PRIME (hybrid graphics) configuration.";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.prime.enable = true;
            }
          '';
          type = lib.types.bool;
        };

        intel_bus_id = lib.mkOption {
          default = null;
          description = "Intel iGPU PCI Bus ID (e.g. \"PCI:0:2:0\"). Required when PRIME is enabled.";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.prime.intel_bus_id = "PCI:0:2:0";
            }
          '';
          type = lib.types.nullOr lib.types.str;
        };

        nvidia_bus_id = lib.mkOption {
          default = null;
          description = "NVIDIA dGPU PCI Bus ID (e.g. \"PCI:1:0:0\"). Required when PRIME is enabled.";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.prime.nvidia_bus_id = "PCI:1:0:0";
            }
          '';
          type = lib.types.nullOr lib.types.str;
        };

        offload.enable = lib.mkOption {
          default = true;
          description = "Enable PRIME render offload (recommended default for laptops).";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.prime.offload.enable = false;
            }
          '';
          type = lib.types.bool;
        };

        sync.enable = lib.mkOption {
          default = false;
          description = "Enable PRIME sync (use instead of offload).";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.prime.sync.enable = true;
            }
          '';
          type = lib.types.bool;
        };
      };

      power_management = {
        enable = lib.mkOption {
          default = true;
          description = "Enable NVIDIA power management (sets NVreg_PreserveVideoMemoryAllocations=1). Prevents the driver from reclaiming GPU memory allocations, improving Wayland rendering stability.";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.power_management.enable = false;
            }
          '';
          type = lib.types.bool;
        };
      };

      wayland = {
        wlr_no_hardware_cursors.enable = lib.mkOption {
          default = true;
          description = "Set WLR_NO_HARDWARE_CURSORS=1 (wlroots cursor workaround).";
          example = lib.literalExpression ''
            {
              eiros.system.hardware.graphics.nvidia.wayland.wlr_no_hardware_cursors.enable = false;
            }
          '';
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
      {
        assertion =
          eiros_nvidia.prime.intel_bus_id == null
          || lib.match "PCI:[0-9]+:[0-9]+:[0-9]+" eiros_nvidia.prime.intel_bus_id != null;
        message = "eiros.system.hardware.graphics.nvidia.prime.intel_bus_id must be in 'PCI:X:Y:Z' format (e.g. \"PCI:0:2:0\").";
      }
      {
        assertion =
          eiros_nvidia.prime.nvidia_bus_id == null
          || lib.match "PCI:[0-9]+:[0-9]+:[0-9]+" eiros_nvidia.prime.nvidia_bus_id != null;
        message = "eiros.system.hardware.graphics.nvidia.prime.nvidia_bus_id must be in 'PCI:X:Y:Z' format (e.g. \"PCI:1:0:0\").";
      }
    ];

    environment = {
      variables = lib.mkIf nvidia_enabled (
        # GBM_BACKEND and __GLX_VENDOR_LIBRARY_NAME must not be set globally in PRIME
        # offload mode; they would force all rendering through NVIDIA even for iGPU clients.
        (lib.optionalAttrs (!prime_offload_enabled) {
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        })
        // (lib.optionalAttrs eiros_nvidia.wayland.wlr_no_hardware_cursors.enable {
          WLR_NO_HARDWARE_CURSORS = "1";
        })
      );
    };

    hardware = {
      graphics = {
        enable = true;

        enable32Bit = eiros_graphics.bits_32.enable;

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

          powerManagement = {
            enable = eiros_nvidia.power_management.enable;
          };

          nvidiaSettings = eiros_nvidia.settings.enable;
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

      nvidia-container-toolkit = lib.mkIf (nvidia_enabled && eiros_nvidia.container_toolkit.enable) {
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
