# Adapted from https://github.com/Misterio77/nix-starter-configs

{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    minegrub-theme.url = "github:Lxtharia/minegrub-theme/b6f8a3a7e2fd22d72e2dbdaf563ad0bcb5c78e45";
    minegrub-theme.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, home-manager, nur, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#nixos'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./nixos/configuration.nix
          inputs.minegrub-theme.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nils = import ./home-manager/desktop.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#nils@nixos'
    homeConfigurations = {
      "nilsh@LAPTOP-Nils" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/common.nix
          ./home-manager/laptop.nix
          ./home-manager/git.nix
        ];
      };
    };
  };
}
