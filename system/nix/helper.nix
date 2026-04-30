# Installs the eiros helper CLI for common system management tasks.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  eiros_helper = config.eiros.system.nix.helper;
  zsh_enabled = config.eiros.system.default_applications.shells.zsh.enable;
in
{
  options.eiros.system.nix.helper = {
    enable = lib.mkOption {
      default = true;
      description = "Install the eiros helper script.";
      example = lib.literalExpression ''
        {
          eiros.system.nix.helper.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_helper.enable {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "eiros";
        runtimeInputs = [ pkgs.nh pkgs.nix ];
        text = ''
          cmd="''${1:-}"

          case "$cmd" in
            update)
              if [[ -z "''${EIROS_USERS_URL:-}" ]]; then
                echo "error: EIROS_USERS_URL is not set" >&2
                exit 1
              fi
              if [[ -z "''${EIROS_HARDWARE_URL:-}" ]]; then
                echo "error: EIROS_HARDWARE_URL is not set" >&2
                exit 1
              fi
              nix flake update \
                --override-input eiros_users "$EIROS_USERS_URL" \
                --override-input eiros_hardware "$EIROS_HARDWARE_URL"
              ;;
            rebuild)
              if [[ -z "''${EIROS_USERS_URL:-}" ]]; then
                echo "error: EIROS_USERS_URL is not set" >&2
                exit 1
              fi
              if [[ -z "''${EIROS_HARDWARE_URL:-}" ]]; then
                echo "error: EIROS_HARDWARE_URL is not set" >&2
                exit 1
              fi
              nh os boot "''${NH_FLAKE:-.}#default" -- \
                --override-input eiros_users "$EIROS_USERS_URL" \
                --override-input eiros_hardware "$EIROS_HARDWARE_URL"
              ;;
            *)
              echo "Usage: eiros <command>"
              echo ""
              echo "Commands:"
              echo "  update     Update flake inputs (nix flake update)"
              echo "  rebuild    Rebuild and boot the system (nh os boot)"
              exit 1
              ;;
          esac
        '';
      })
    ] ++ lib.optionals zsh_enabled [
      (pkgs.writeTextFile {
        name = "eiros-zsh-completion";
        destination = "/share/zsh/site-functions/_eiros";
        text = ''
          #compdef eiros

          _eiros() {
            local -a commands
            commands=(
              'update:Update all flake inputs (nix flake update)'
              'rebuild:Rebuild and boot the system (nh os boot)'
            )
            _describe 'command' commands
          }

          _eiros "$@"
        '';
      })
    ];
  };
}
