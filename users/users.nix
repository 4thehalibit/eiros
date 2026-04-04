{ config, lib, ... }:

let
  mangowc_generator = lib.generators.toKeyValue {
    mkKeyValue =
      name: value:
      if lib.isList value then
        lib.concatMapStringsSep "\n" (v: "${name}=${toString v}") value
      else
        "${name}=${toString value}";
  };

  to_string_list =
    v:
    if v == null then
      [ ]
    else if lib.isList v then
      map toString v
    else
      [ (toString v) ];

  make_bind_line =
    kb:
    let
      modifier_keys_str = lib.concatStringsSep "+" kb.modifier_keys;
      command_args_str = if kb.command_arguments == null then "" else kb.command_arguments;
    in
    "${modifier_keys_str},${kb.key_symbol},${kb.mangowc_command},${command_args_str}";

  dms_exec_once =
    lib.optionalAttrs config.eiros.system.desktop_environment.dank_material_shell.enable {
      "exec-once" =
        [
          "dms run"
          "udiskie &"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots"
        ];
    };

  wallpaper_exec_once =
    mangowc_cfg:
    lib.optionalAttrs (mangowc_cfg.wallpaper != null) {
      "exec-once" = [ "dms ipc call wallpaper set ${mangowc_cfg.wallpaper}" ];
    };

  make_mangowc_config =
    mangowc_cfg:
    let
      extra_bind_attrs = builtins.foldl' (
        acc: kb:
        let
          flags_str = lib.concatStrings (kb.flag_modifiers or [ ]);
          bind_key = "bind" + flags_str;
          line = make_bind_line kb;
          previous = acc.${bind_key} or [ ];
        in
        acc // { ${bind_key} = previous ++ [ line ]; }
      ) { } (lib.attrValues mangowc_cfg.keybinds);
    in
    mangowc_cfg.settings
    // dms_exec_once
    // wallpaper_exec_once mangowc_cfg
    // lib.mapAttrs (
      name: lines: (to_string_list (mangowc_cfg.settings.${name} or [ ])) ++ lines
    ) extra_bind_attrs;
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
                        type = lib.types.attrsOf (
                          lib.types.submodule (
                            { name, ... }:
                            {
                              options = {
                                command_arguments = lib.mkOption {
                                  default = null;
                                  description = "Optional command arguments.";
                                  type = lib.types.nullOr lib.types.str;
                                };

                                flag_modifiers = lib.mkOption {
                                  default = [ ];
                                  description = ''
                                    MangoWC bind flags:
                                    l (lock), r (release), s (keysym).
                                  '';
                                  example = [
                                    "l"
                                    "s"
                                  ];
                                  type = lib.types.listOf (
                                    lib.types.enum [
                                      "l"
                                      "r"
                                      "s"
                                    ]
                                  );
                                };

                                key_symbol = lib.mkOption {
                                  description = "Key symbol such as \"Return\", \"Q\", or \"space\".";
                                  type = lib.types.str;
                                };

                                mangowc_command = lib.mkOption {
                                  description = "MangoWC command (e.g., \"spawn\", \"killclient\", \"quit\").";
                                  type = lib.types.str;
                                };

                                modifier_keys = lib.mkOption {
                                  default = [ ];
                                  description = "Modifier keys joined using '+', e.g., [\"SUPER\" \"SHIFT\"].";
                                  type = lib.types.listOf lib.types.str;
                                };
                              };
                            }
                          )
                        );
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
            value = make_mangowc_config mangowc_cfg;
          };
        };
      }
    ) config.eiros.users;
  };
}
