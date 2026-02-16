{
  description = "ThinkPad E14 Home Manager Flake (release-25.11)";

  inputs = {
    # Pinned to the 25.11 stable release
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."hanz" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Pass inputs to modules
        extraSpecialArgs = { inherit inputs; };

        modules = [
          ./home.nix
        ];
      };
    };
}
