default:
	NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#mkDarwin --impure
