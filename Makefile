default:
	sudo NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#mkDarwin --impure

update:
	NIXPKGS_ALLOW_UNFREE=1 nix flake update

fallback:
	NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 sudo darwin-rebuild switch --flake .#mkDarwin --impure --fallback

build:
	env NIXPKGS_ALLOW_UNFREE=1 env NIXPKGS_ALLOW_INSECURE=1 nix build .#darwinConfigurations.mkDarwin.system --impure

post-build:
	sudo NIXPKGS_ALLOW_UNFREE=1 ./result/sw/bin/darwin-rebuild switch --flake .#mkDarwin --impure

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
	NIXPKGS_ALLOW_UNFREE=1 nix config check

fix-channel:
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	nix-channel --update nixpkgs

gc:
	nix store gc
	nix-collect-garbage -d
	nix-collect-garbage -d


fix-ownership:
	chown -R $(USER):staff /nix
