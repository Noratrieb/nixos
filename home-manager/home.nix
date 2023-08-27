# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs
, lib
, config
, pkgs
, ...
}:
let
  customPkgs = import ../custom-pkgs/default.nix pkgs;
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      inputs.nur.overlay
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "nils";
    homeDirectory = "/home/nils";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    discord
    spotify
    nixpkgs-fmt
    rnix-lsp
    fzf
    linuxKernel.packages.linux_6_1.perf
    cargo-nextest
    git-absorb
    gcc
    jetbrains.idea-ultimate
    htop
    ripgrep
    bat
    postman
    rustup-toolchain-install-master
    inferno
    gh
    obsidian
    customPkgs.cargo-bisect-rustc
    audacity
    prismlauncher
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;

    userEmail = "48135649+Nilstrieb@users.noreply.github.com";
    userName = "Nilstrieb";

    aliases = {
      hardupdate = "!git fetch && git reset --hard \"origin/$(git rev-parse --abbrev-ref HEAD)\"";
      fpush = "push --force-with-lease";
      resq = "rebase --autosquash -i";
      pfush = "!echo \"hör uf ume z'pfusche und machs richtig\"";
    };
    difftastic = {
      enable = true;
    };
    extraConfig = {
      core.autocrlf = false;
      core.editor = "nvim";
      pull.ff = "only";
      init.defaultBranch = "main";
    };
  };

  programs.firefox = {
    enable = true;
    profiles = {
      nils = {
        id = 0;
        name = "nils";

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
        ];

        bookmarks = [
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "NixOS options";
                url = "https://search.nixos.org/options";
              }
              {
                name = "home-manager options";
                url = "https://rycee.gitlab.io/home-manager/options.html";
              }
              {
                name = "nixpkgs search";
                url = "https://search.nixos.org/packages";
              }
            ];
          }
        ];
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      usernamehw.errorlens
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      eamodio.gitlens
      tamasfe.even-better-toml
      ms-vscode-remote.remote-ssh
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      ms-python.python
      redhat.vscode-yaml
      mads-hartmann.bash-ide-vscode
      ms-azuretools.vscode-docker
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "dtsvet";
        name = "vscode-wasm";
        version = "1.4.1";
        sha256 = "sha256-zs7E3pxf4P8kb3J+5zLoAO2dvTeepuCuBJi5s354k0I=";
      }
      {
        publisher = "redhat";
        name = "ansible";
        version = "2.7.98";
        sha256 = "sha256-b3Z40IeQbtYci2LA4/OlJkfqMB78cWRNTNWd89lfhy4=";
      }
      {
        publisher = "matthewpi";
        name = "caddyfile-support";
        version = "0.3.0";
        sha256 = "sha256-1yiOnvC2w33kiPRdQYskee38Cid/GOj9becLadP1fUY=";
      }
    ] ++ [
      (pkgs.vscode-utils.buildVscodeExtension {
        name = "riverdelta";
        version = "0.1.0";
        src = builtins.fetchGit {
          url = "https://github.com/Nilstrieb/riverdelta";
          rev = "64d81b56084d9a7663517b367b4533fb8ea83a92";
        };
        vscodeExtPublisher = "Nilstrieb";
        vscodeExtName = "riverdelta";
        vscodeExtUniqueId = "Nilstrieb.riverdelta";
        buildPhase = ''
          runHook preBuild;
          cd ./vscode
          runHook postBuild;
        '';
      })
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
