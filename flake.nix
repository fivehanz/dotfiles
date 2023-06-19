{
  description = "root nix flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		# links configs to home directory 
		home-manager.url = "github:nix-community/home-manager/release-23.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		# system level settings; softwares
		darwin.url = "github:lnl7/nix-darwin";
		darwin.inputs.nixpkgs.follows = "nixpkgs";

	};

  outputs = inputs: {
	darwinConfigurations.zbook = inputs.darwin.lib.darwinSystem {
		
		system = "aarch64-darwin";
		pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };

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

			services.nix-daemon.enable = true;
		})
	
	inputs.home-manager.darwinModules.home-manager {
	
	home-manager = {
            	useGlobalPkgs = true;
            	useUserPackages = true;
             	users.hanz.imports = [
                
		({ pkgs, ... }: {
                  	# Don't change this when you change package input. Leave it alone.
                  	home.stateVersion = "23.05";
                  	# specify my home-manager configs
                  	home.packages = [ pkgs.ripgrep pkgs.fd pkgs.curl pkgs.less ];
                  	home.sessionVariables = {
                    		PAGER = "less";
                    		CLICLOLOR = 1;
                    		EDITOR = "nvim";
                  	};
                  	programs.bat.enable = true;
                  	programs.bat.config.theme = "TwoDark";
                  	programs.fzf.enable = true;
                  	programs.fzf.enableZshIntegration = true;
                  	programs.exa.enable = true;
                  	programs.git.enable = true;
                  	programs.zsh.enable = true;
                  	programs.zsh.shellAliases = { ls = "ls --color=auto -F"; };
			programs.starship.enable = true;
                  	programs.starship.enableZshIntegration = true;	
                })
		];
            };
          }
	];

	};
  };
}
