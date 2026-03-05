{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_virtualization = config.eiros.system.virtualization;
  eiros_virt_manager = eiros_virtualization.virt_manager;

  spice_gtk_package = pkgs.spice-gtk;
  usbredir_package = pkgs.usbredir;
  virt_viewer_package = pkgs.virt-viewer;

  extra_packages =
    (lib.optionals eiros_virt_manager.spice_gtk.enable [ spice_gtk_package ])
    ++ (lib.optionals eiros_virt_manager.usbredir.enable [ usbredir_package ])
    ++ (lib.optionals eiros_virt_manager.virt_viewer.enable [ virt_viewer_package ]);
in
{
  options.eiros.system.virtualization.virt_manager = {
    enable = lib.mkOption {
      default = true;
      description = "Virtual machine manager GUI.";
      type = lib.types.bool;
    };

    shared_folder_support.enable = lib.mkOption {
      default = true;
      description = "Enable shared folder support in virt-manager (virtiofsd).";
      type = lib.types.bool;
    };

    spice_gtk.enable = lib.mkOption {
      default = true;
      description = "Install spice-gtk for SPICE client integration.";
      type = lib.types.bool;
    };

    usbredir.enable = lib.mkOption {
      default = true;
      description = "Install usbredir for USB redirection support.";
      type = lib.types.bool;
    };

    virt_viewer.enable = lib.mkOption {
      default = true;
      description = "Install virt-viewer for viewing virtual machine consoles.";
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

        qemu = {
          vhostUserPackages = lib.mkIf eiros_virt_manager.shared_folder_support.enable [
            pkgs.virtiofsd
          ];
        };
      };
    };
  };
}
