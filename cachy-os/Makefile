# Variables
USER := hanz
FLAKE_URI := $(USER)
NIX_FLAGS := --impure

.PHONY: default switch update build repair verify doctor gc trust-user

default: switch

# Apply the Home Manager config
switch:
	nix run home-manager -- switch --flake .#$(FLAKE_URI) $(NIX_FLAGS)

# Update inputs (nixpkgs, home-manager)
update:
	nix flake update

# Build without switching
build:
	nix build .#homeConfigurations.$(FLAKE_URI).activationPackage $(NIX_FLAGS)

# Verify store integrity
verify:
	nix store verify --all

# Garbage Collection
gc:
	nix-collect-garbage -d

# Check if everything is healthy
doctor:
	nix config check
