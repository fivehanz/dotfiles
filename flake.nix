####
## nix build .#darwinConfigurations.mkDarwin.system
## ./result/sw/bin/darwin-rebuild switch --flake ~/Projects/dotfiles#mkDarwin
## darwin-rebuild switch --flake ~/Projects/dotfiles#mkDarwin
####
{
  description = "root & home-manager nix flake";

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

    # snowfall-lib = {
    #   url = "github:snowfallorg/lib";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # plusultra = {
    #   url = "github:jakehamilton/config";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.unstable.follows = "nixpkgs-unstable";
    # };
  };

  outputs = inputs: {
    formatter.aarch64-darwin = inputs.nixpkgs.legacyPackages.aarch64-darwin.alejandra;

    darwinConfigurations = {
      mkDarwin = inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };

        modules = [
          ({pkgs, ...}: {
            # darwin configs
            programs.fish.enable = true;
            environment.shells = [pkgs.bash pkgs.fish];
            environment.loginShell = pkgs.fish;

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

            # extra nix configs
            nix.extraOptions = ''
              auto-optimise-store = true
              experimental-features = nix-command flakes
            '';
          })

          inputs.home-manager.darwinModules.home-manager
          {
            users.users.hanz.home = "/Users/hanz";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.hanz.imports = [
                ({pkgs, ...}: {
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
                    du-dust # du + rust
                    neofetch
                    tealdeer # fast tldr
                    neovim

                    httpstat
                    curlie
                    trippy # network diagnostics tool

                    tailscale 
                    caddy # quick web server

                    ## mac desktop specific apps
                    iterm2
                    discord
                    obsidian
                    vscode
                    raycast
                    # inputs.nixpkgs-unstable.legacyPackages.aarch64-darwin.calibre
                    # calibre
                    # amethyst -- not available on nix, use homebrew instead
                  ];

                  home.sessionVariables = {
                    PAGER = "less";
                    CLICLOLOR = 1;
                    EDITOR = "nvim";
                  };

                  # programs to install

                  programs.zoxide = {
                    enable = true; # smarter 'cd'
                    enableFishIntegration = true;
                  };

                  programs.bat.enable = true;
                  # programs.bat.config.theme = "TwoDark";
                  programs.fzf.enable = true;
                  programs.fzf.enableFishIntegration = true;

                  programs.fish.enable = true;
                  programs.fish.shellAliases = {
                    ls = "ls --color=auto -F";
                    cd = "z";
                    cat = "bat";
                  };

                  programs.starship = let
                    flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
                  in {
                    enable = true;
                    enableFishIntegration = true;

                    settings =
                      {
                        # Other config here
                        format = "$all"; # Remove this line to disable the default prompt format
                        palette = "catppuccin_${flavour}";
                      }
                      // builtins.fromTOML (builtins.readFile
                        (pkgs.fetchFromGitHub
                          {
                            owner = "catppuccin";
                            repo = "starship";
                            rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc"; # Replace with the latest commit hash
                            sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
                          }
                          + /palettes/${flavour}.toml));
                  };

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
