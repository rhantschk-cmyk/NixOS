{
  description = "Raphaels NixOS";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:4evy/nixcord";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixcord, nixvim, ...}: {
    nixosConfigurations.nix-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.raphael = import ./home.nix;
            backupFileExtension = "backup";
	    extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  };
}
