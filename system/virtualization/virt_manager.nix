# Configures virt-manager with libvirtd, virtiofsd shared folders, SPICE, and USB redirection.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_virtualization = config.eiros.system.virtualization;
  eiros_virt_manager = eiros_virtualization.virt_manager;

  extra_packages =
    (lib.optionals eiros_virt_manager.spice_gtk.enable [ pkgs.spice-gtk ])
    ++ (lib.optionals eiros_virt_manager.usbredir.enable [ pkgs.usbredir ])
    ++ (lib.optionals eiros_virt_manager.virt_viewer.enable [ pkgs.virt-viewer ]);
in
{
  options.eiros.system.virtualization.virt_manager = {
    enable = lib.mkOption {
      default = true;
      description = "Virtual machine manager GUI.";
      example = lib.literalExpression ''
        {
          eiros.system.virtualization.virt_manager.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    shared_folder_support.enable = lib.mkOption {
      default = true;
      description = "Enable shared folder support in virt-manager (virtiofsd).";
      example = lib.literalExpression ''
        {
          eiros.system.virtualization.virt_manager.shared_folder_support.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    spice_gtk.enable = lib.mkOption {
      default = true;
      description = "Install spice-gtk for SPICE client integration.";
      example = lib.literalExpression ''
        {
          eiros.system.virtualization.virt_manager.spice_gtk.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    usbredir.enable = lib.mkOption {
      default = true;
      description = "Install usbredir for USB redirection support.";
      example = lib.literalExpression ''
        {
          eiros.system.virtualization.virt_manager.usbredir.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    virt_viewer.enable = lib.mkOption {
      default = true;
      description = "Install virt-viewer for viewing virtual machine consoles.";
      example = lib.literalExpression ''
        {
          eiros.system.virtualization.virt_manager.virt_viewer.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    windows_11.enable = lib.mkOption {
      default = true;
      description = "Enable Windows 11 guest VM support (swtpm TPM 2.0 emulator; UEFI/Secure Boot firmware is bundled with QEMU by default).";
      example = lib.literalExpression ''
        {
          eiros.system.virtualization.virt_manager.windows_11.enable = true;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (eiros_virtualization.enable && eiros_virt_manager.enable) {
    assertions = [
      {
        assertion = eiros_virt_manager.virt_viewer.enable || eiros_virt_manager.spice_gtk.enable;
        message = "virt-manager is enabled but no console viewer is installed; enable virt_viewer.enable or spice_gtk.enable.";
      }
    ];

    environment = {
      systemPackages = extra_packages;
    };

    programs = {
      virt-manager = {
        enable = true;
      };
    };

    virtualisation = {
      libvirtd = {
        enable = true;

        qemu = lib.mkMerge [
          {
            vhostUserPackages = lib.mkIf eiros_virt_manager.shared_folder_support.enable [
              pkgs.virtiofsd
            ];
          }
          (lib.mkIf eiros_virt_manager.windows_11.enable {
            swtpm.enable = true;
          })
        ];
      };
    };
  };
}
