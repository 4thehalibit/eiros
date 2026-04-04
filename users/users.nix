{ config, lib, ... }:

let
  helpers = import ../resources/nix/mangowc_helpers.nix lib;
  inherit (helpers) mangowc_generator make_mangowc_config keybind_submodule;

  mangowc_systemd_exec_once =
    let
      mangowc_systemd = config.eiros.system.desktop_environment.mangowc.systemd;
      vars_str = lib.concatStringsSep " " mangowc_systemd.variables;
    in
    lib.optionalAttrs (config.eiros.system.desktop_environment.mangowc.enable && mangowc_systemd.enable) {
      "exec-once" = [
        "systemctl --user import-environment ${vars_str}"
        "dbus-update-activation-environment --systemd ${vars_str}"
      ];
    };

  dms_exec_once =
    lib.optionalAttrs config.eiros.system.desktop_environment.dank_material_shell.enable {
      "exec-once" = [
        "dms run"
        "udiskie &"
      ];
    };

  wallpaper_exec_once =
    mangowc_cfg:
    lib.optionalAttrs (mangowc_cfg.wallpaper != null) {
      "exec-once" = [ "dms ipc call wallpaper set ${mangowc_cfg.wallpaper}" ];
    };

  make_user_mangowc_config =
    mangowc_cfg:
    make_mangowc_config mangowc_cfg
    // mangowc_systemd_exec_once
    // dms_exec_once
    // wallpaper_exec_once mangowc_cfg;
in
{
  options = {
    eiros.users = lib.mkOption {
      default = { };
      description = "Per-user configuration for the eiros system, including MangoWC and home management.";
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              extra_groups = lib.mkOption {
                default = [
                  "wheel"
                  "networkmanager"
                  "libvirtd"
                ];
                description = "Additional groups for the user.";
                type = lib.types.listOf lib.types.str;
              };

              initial_password = lib.mkOption {
                default = name;
                description = "Initial password for the user. WARNING: defaults to the username — change this before deploying to a real system.";
                type = lib.types.str;
              };

              mangowc = lib.mkOption {
                default = null;
                description = "Per-user MangoWC configuration (or null if unused).";
                type = lib.types.nullOr (
                  lib.types.submodule {
                    options = {
                      clobber_home_directory = lib.mkOption {
                        default = true;
                        description = "Whether hjem is allowed to clobber the existing home directory.";
                        type = lib.types.bool;
                      };

                      wallpaper = lib.mkOption {
                        default = null;
                        description = "Absolute path to the wallpaper image. When set, runs `dms ipc call wallpaper set <path>` on login.";
                        type = lib.types.nullOr lib.types.path;
                      };

                      keybinds = lib.mkOption {
                        default = { };
                        description = "Structured MangoWC keybind declarations.";
                        type = lib.types.attrsOf keybind_submodule;
                      };

                      settings = lib.mkOption {
                        default = { };
                        description = "Raw MangoWC settings written as key=value pairs.";
                        type = lib.types.attrsOf (
                          lib.types.oneOf [
                            lib.types.str
                            lib.types.int
                            (lib.types.listOf lib.types.str)
                          ]
                        );
                      };
                    };
                  }
                );
              };
            };
          }
        )
      );
    };
  };

  config = {
    warnings = lib.flatten (
      lib.mapAttrsToList (
        username: user_config:
        lib.optional (user_config.initial_password == username)
          "User '${username}' has initial_password set to their username — change this before deploying to a real system."
      ) config.eiros.users
    );

    assertions = lib.flatten (
      lib.mapAttrsToList (
        username: user_config:
        lib.optional (
          user_config.mangowc != null && !config.eiros.system.desktop_environment.mangowc.enable
        ) {
          assertion = false;
          message = "User '${username}' has mangowc config but eiros.system.desktop_environment.mangowc.enable is false.";
        }
      ) config.eiros.users
    );

    users.users = lib.mapAttrs (username: user_config: {
      description = lib.mkDefault username;
      extraGroups = lib.mkDefault user_config.extra_groups;
      initialPassword = lib.mkDefault user_config.initial_password;
      isNormalUser = lib.mkDefault true;
    }) config.eiros.users;

    hjem.users = lib.mapAttrs (
      username: user_config:
      let
        mangowc_cfg = user_config.mangowc;
        mangowc_enabled = config.eiros.system.desktop_environment.mangowc.enable && mangowc_cfg != null;
      in
      {
        directory = lib.mkDefault "/home/${username}";
        user = username;

        files = lib.optionalAttrs mangowc_enabled {
          ".config/mango/config.conf" = {
            clobber = lib.mkDefault mangowc_cfg.clobber_home_directory;
            generator = mangowc_generator;
            value = make_user_mangowc_config mangowc_cfg;
          };
        };
      }
    ) config.eiros.users;
  };
}
