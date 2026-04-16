{
  description = "Eiros: A NixOS configuration using MangoWC";

  outputs =
    {
      dank_material_shell,
      eiros_hardware,
      eiros_users,
      hjem,
      mango,
      nix-index-database,
      nixpkgs,
      nixvim,
      sops-nix,
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
          nix-index-database
          nixpkgs
          nixvim
          sops-nix
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
          nix-index-database.nixosModules.nix-index-database
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
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

    eiros_hardware = {
      url = "github:lcleveland/eiros.hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eiros_users = {
      url = "github:lcleveland/eiros.users";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
