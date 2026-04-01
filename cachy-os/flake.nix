{
  description = "ThinkPad E14 Home Manager Flake (release-25.11)";

  inputs = {
    # Pinned to the 25.11 stable release
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
   
    # unstable for latest pkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      genericModules = [
	({config, pkgs, ...}: {
		nixpkgs.overlays = [
			overlay-unstable
		];
	})
      ];

      # overlay nixpkgs-unstable
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

    in {
      homeConfigurations."hanz" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Pass inputs to modules
        extraSpecialArgs = { inherit inputs; };

        modules = genericModules ++ [
          ./home.nix
        ];
      };
    };
}
