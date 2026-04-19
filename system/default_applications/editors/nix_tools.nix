# Installs Nix language tooling: nil LSP server and nixfmt formatter.
{ config, lib, pkgs, ... }:
let
  eiros_nix_tools = config.eiros.system.default_applications.editors.nix_tools;
in
{
  options.eiros.system.default_applications.editors.nix_tools = {
    enable = lib.mkOption {
      default = true;
      description = "Install Nix language tooling.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nix_tools.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    lsp.enable = lib.mkOption {
      default = true;
      description = "Install nil, a Nix language server providing LSP support for editors.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nix_tools.lsp.enable = false;
        }
      '';
      type = lib.types.bool;
    };

    formatter.enable = lib.mkOption {
      default = true;
      description = "Install nixfmt, the RFC-style Nix code formatter.";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.editors.nix_tools.formatter.enable = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_nix_tools.enable {
    environment.systemPackages =
      lib.optionals eiros_nix_tools.lsp.enable [ pkgs.nil ]
      ++ lib.optionals eiros_nix_tools.formatter.enable [ pkgs.nixfmt ];
  };
}
