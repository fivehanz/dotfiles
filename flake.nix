####
## nix build .#darwinConfigurations.mkDarwin.system
## ./result/sw/bin/darwin-rebuild switch --flake ~/Projects/dotfiles#mkDarwin
## darwin-rebuild switch --flake .#mkDarwin
####
{
  description = "root & home-manager nix flake";

  inputs = {
    # nixpkgs url
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # links configs to home directory
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # system level settings; softwares
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

            environment.systemPackages = with pkgs; [
              coreutils
              rustup
              sccache
              bacon
              ripgrep
              tailscale
              ansible
              pipx # python pkg 
              uv # python package manager 
              sniffnet # internet observability
              nghttp2 # http2 tool

              ## running containers on apple silicon
              # colima
              # docker-client
              ##

              fd
              curl
              less
              neofetch
              htop
              gh
              lazygit
              riffdiff # better diff
              gfold # git repo management
              oxker # docker tui
              tealdeer # fast tldr
              alejandra # nix formatter
              xh
              ripsecrets
              atuin
              k6 # load testing tool


              lld_16 # fast apple linker
              glow # markdown reader
              mods # charm ai llm
              # k9s # cli k8s ide
              # kubectl
              # utm
              
              protobuf
              grpcui
              grpcurl

              
              mise # rtx
              discord
              vscode
              raycast
            ];

            services.tailscale.enable = true;
            
            system.stateVersion = 5; # don't know why, but it fixes build
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToEscape = true;

            system.defaults.dock.autohide = true;
            system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
            system.defaults.NSGlobalDomain.KeyRepeat = 1;

            # Auto upgrade nix package and the daemon service.
            services.nix-daemon.enable = true;

            # extra nix configs
            nix.optimise.automatic = true;
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
                    ## mac desktop specific apps
                    qbittorrent
                    mpv-unwrapped
                    iina # video player for macOS
                    # inputs.nixpkgs-unstable.legacyPackages.aarch64-darwin.calibre
                    # calibre
                    # amethyst # -- not available on nix, use homebrew instead
                  ];

                  home.sessionVariables = {
                    PAGER = "less";
                    CLICLOLOR = 1;
                    EDITOR = "nvim";
                    ZELLIJ_AUTO_EXIT = "true";
                  };

                  # programs to install

                  # programs.rtx = {
                  # enable = true;
                  # enableFishIntegration = true;
                  # };

                  programs.neovim = {
                    enable = true;
                    viAlias = true;
                    vimAlias = true;
                    # extraPackages = with pkgs; [gcc];
                  };

                  programs.zoxide = {
                    enable = true; # smarter 'cd'
                    enableFishIntegration = true;
                  };

                  programs.bat.enable = true;
                  programs.fzf.enable = true;
                  programs.fzf.enableFishIntegration = true;
                  programs.lsd.enable = true;
                  programs.lsd.enableAliases = true;

                  programs.fish = {
                    enable = true;
                    shellAliases = {
                      # cd = "z";
                      zj = "zellij";
                      lg = "lazygit";
                      gs = "git status -s";
                      cat = "bat";
                      n = "nvim";
                      vim = "nvim";
                      rtx = "mise";
                    };
                    shellInit = ''
                      mise activate fish | source
                      atuin init fish | source
                      eval "$(/opt/homebrew/bin/brew shellenv)"
                      '';
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

                    ignores = [
                      ".direnv"
                    ];

                    extraConfig = {
                      pull.rebase = true;
                      init.defaultBranch = "main";
                      github.user = "fivehanz";
                    };
                  };

                  programs.wezterm = {
                    enable = true;
                    extraConfig = ''
                      return {
                        color_scheme = 'tokyonight',
                        window_background_opacity = 0.90,
                        macos_window_background_blur = 20,
                      }
                    '';
                  };

                  programs.zellij = {
                    enable = true;
                    # enableFishIntegration = true;
                    settings = {
                      simplified_ui = true;
                    };
                  };

                  programs.direnv = {
                    enable = true;
                    nix-direnv.enable = true;
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
