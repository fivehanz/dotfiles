{
	description = "root nix flake";

	inputs = {
		# nixpkgs url
		nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		# links configs to home directory 
		home-manager = {
			url = "github:nix-community/home-manager/release-23.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# system level settings; softwares
		darwin = {
			url = "github:lnl7/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs: {
		darwinConfigurations = {
			
			mba2020 = inputs.darwin.lib.darwinSystem {
				system = "aarch64-darwin";
				pkgs = import inputs.nixpkgs { 
					system = "aarch64-darwin";
					config.allowUnfree = true;
				};

				modules = [
					({pkgs, ...}: {
						# darwin configs
						programs.zsh.enable = true;
						environment.shells = [pkgs.bash pkgs.zsh];
						environment.loginShell = pkgs.zsh;

						
						environment.systemPackages = [
							pkgs.coreutils
						];

						system.keyboard.enableKeyMapping = true;
						system.keyboard.remapCapsLockToEscape = true;

						system.defaults.dock.autohide = true;
						system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
						system.defaults.NSGlobalDomain.KeyRepeat = 1;	

						# Auto upgrade nix package and the daemon service.
						services.nix-daemon.enable = true;
					})

					inputs.home-manager.darwinModules.home-manager {
						home-manager = {
							useGlobalPkgs = true;
							useUserPackages = true;

							users.hanz.imports = [
								({ pkgs, ... }: {
									home.username = "hanz";
									home.homeDirectory = pkgs.lib.mkDefault "/Users/hanz";

									### Don't change this when you change package input. Leave it alone. ###
									home.stateVersion = "23.05";
									### --- ###

									home.packages = with pkgs; [
										ripgrep
										fd
										curl
										less
										du-dust	# du + rust
										zoxide	# smarter 'cd'
										tmux
										neofetch
										tealdeer # fast tldr
										iterm2
										neovim

										httpstat
										curlie

										tailscale
										caddy

										discord
										obsidian
										spotify
									];

									home.sessionVariables = {
										PAGER = "less";
										CLICLOLOR = 1;
										EDITOR = "nvim";
									};

									# programs to install
									programs.bat.enable = true;
									programs.bat.config.theme = "TwoDark";
									programs.fzf.enable = true;
									programs.fzf.enableZshIntegration = true;
									programs.exa.enable = true;
									programs.zsh.enable = true;
									programs.zsh.shellAliases = { ls = "ls --color=auto -F"; };
									programs.starship.enable = true;
									programs.starship.enableZshIntegration = true;

									# Let Home Manager install and manage itself.
									programs.home-manager.enable = true;

									# configure git
									programs.git = {
										enable = true;
										userName = "Hanz";
										userEmail = "haniel56@zoho.eu";

										extraConfig = {
											pull.rebase = true;
											init.defaultBranch = "main";
											github.user = "fivehanz";
										};
									};	

									programs.tmux = {
										enable = true;
										clock24 = true;
									};
								})
							];
						};
					}
				];
			};
		};
	};
}
