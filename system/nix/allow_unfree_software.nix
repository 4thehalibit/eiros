# Controls whether unfree nixpkgs packages are allowed, with optional per-package predicates.
{ config, lib, ... }:
let
  eiros_nix = config.eiros.system.nix;
in
{
  options.eiros.system.nix = {
    allow_unfree_software.enable = lib.mkOption {
      default = true;
      description = "Allow unfree software in Eiros.";
      example = false;
      type = lib.types.bool;
    };

    allow_unfree_software.predicates = lib.mkOption {
      default = [ ];
      description = ''
        Optional list of match strings to allow specific unfree packages. Each
        entry is matched against a package name (pname/name) using substring
        matching. If empty, all unfree packages are allowed when
        allow_unfree_software.enable is true.
      '';
      example = [
        "nvidia"
        "vivaldi"
      ];
      type = lib.types.listOf lib.types.str;
    };
  };

  config = {
    warnings = lib.optionals (!eiros_nix.allow_unfree_software.enable) [
      "Unfree software is disabled; some hardware drivers or firmware may not be available."
    ];

    nixpkgs = {
      config =
        if eiros_nix.allow_unfree_software.enable then
          {
            allowUnfree = true;

            allowUnfreePredicate =
              pkg:
              let
                name = (pkg.pname or pkg.name or "");
              in
              eiros_nix.allow_unfree_software.predicates == [ ]
              || lib.any (p: lib.hasInfix p name) eiros_nix.allow_unfree_software.predicates;
          }
        else
          {
            allowUnfree = false;
          };
    };
  };
}
