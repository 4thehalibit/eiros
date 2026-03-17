{
  description = "Eiros: A NixOS configuration using MangoWC";

  outputs =
    {
      dank_material_shell,
      eiros_hardware,
      eiros_users,
      hjem,
      mango,
      nixpkgs,
      self,
      ...
    }:
    let
      inputs = {
        inherit
          dank_material_shell
          eiros_hardware
          eiros_users
          hjem
          mango
          nixpkgs
          ;
      };

      import_modules = import ./resources/nix/import_modules.nix;
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules = [
          dank_material_shell.nixosModules.dank-material-shell
          dank_material_shell.nixosModules.greeter
          eiros_hardware.nixosModules.default
          eiros_users.nixosModules.default
          hjem.nixosModules.default
          mango.nixosModules.mango
        ]
        ++ (import_modules ./system)
        ++ (import_modules ./users);

        specialArgs = { inherit inputs; };
      };
    };

  inputs = {
    dank_material_shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eiros_hardware.url = "github:lcleveland/eiros.hardware";

    eiros_users = {
      url = "github:lcleveland/eiros.users";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem.url = "github:feel-co/hjem";

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/master";
  };
}
