{ config, pkgs, ... }:

{
  # 1. User & Path Config
  home.username = "hanz";
  home.homeDirectory = "/home/hanz";

  # 2. State Version (Matches your release)
  home.stateVersion = "25.11";

  # 3. Enable Home Manager
  programs.home-manager.enable = true;

  # Disable documentation and speed up builds
  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;


    # ---------------------------------------------------------------------
    # KDE KEYBOARD REMAP (Caps -> Escape)
    # ---------------------------------------------------------------------
    # This writes to ~/.config/kxkbrc, which KDE Plasma reads.
    xdg.configFile."kxkbrc".text = ''
      [Layout]
      DisplayNames=
      LayoutList=us
      LayoutLoopCount=-1
      Model=pc105
      # caps:escape maps CapsLock to Esc.
      # Use caps:swapescape if you want to swap them instead.
      Options=caps:escape
      ResetOldOptions=true
      ShowFlag=false
      ShowLabel=true
      ShowLayoutIndicator=true
      ShowSingle=false
      SwitchMode=Global
    '';

  # 4. Packages
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # -- System Utilities --
    coreutils
    ripgrep
    fd
    curl
    less
    neofetch
    htop
    gh
    lazygit
    riffdiff
    tealdeer
    alejandra
    xh
    atuin
    k6
    glow
    ncdu
    mise

    # -- GUI Apps --
    qbittorrent

    # -- Dev --
    ansible
    gcc
  ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nvim";
    ZELLIJ_AUTO_EXIT = "true";
  };

  # 5. Program Configurations

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      zj = "zellij";
      lg = "lazygit";
      gs = "git status";
      gcom = "git commit";
      gpush = "git push";
      gpull = "git pull";
      glog = "git log";
      gdiff = "git diff";
      cat = "bat";
      n = "nvim";
      vim = "nvim";
    };
    shellInit = ''
      mise activate fish | source
      atuin init fish | source
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = "$all";
      palette = "catppuccin_mocha";
    } // builtins.fromTOML (builtins.readFile
      (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "starship";
          rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc";
          sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
        }
        + /palettes/mocha.toml));
  };

  programs.git = {
    enable = true;
    # Using extraConfig to map settings exactly as requested
    settings = {
      user = {
        name = "Hanz";
        email = "haniel56@zoho.eu";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      github = {
        user = "fivehanz";
      };
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore";
      };
    };
    ignores = [ ".direnv" ];
  };

  programs.zellij = {
    enable = true;
    settings = {
      simplified_ui = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
