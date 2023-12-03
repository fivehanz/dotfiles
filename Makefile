default:
	env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#mkDarwin --impure

fallback:
	NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#mkDarwin --impure --fallback

build:
	env NIXPKGS_ALLOW_UNFREE=1 nix build .#darwinConfigurations.mkDarwin.system --impure

post-build:
	env NIXPKGS_ALLOW_UNFREE=1 ./result/sw/bin/darwin-rebuild switch --flake .#mkDarwin --impure


repair:
	sudo nix-store --verify --check-contents --repair

verify:
	NIXPKGS_ALLOW_UNFREE=1 nix store verify .#darwinConfigurations.mkDarwin.system --impure

delete:
	NIXPKGS_ALLOW_UNFREE=1 nix store delete .#darwinConfigurations.mkDarwin.system --impure

sign:
	NIXPKGS_ALLOW_UNFREE=1 nix store sign .#darwinConfigurations.mkDarwin.system --impure

optimise:
	NIXPKGS_ALLOW_UNFREE=1 nix store optimise

doctor:
	NIXPKGS_ALLOW_UNFREE=1 nix doctor

update-channel:
	sudo -i nix-channel --update nixpkgs

gc: 
	NIXPKGS_ALLOW_UNFREE=1 nix store gc
