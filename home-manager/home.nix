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

  /*nixpkgs = {
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
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };*/

  home = {
    username = "nils";
    homeDirectory = "/home/nils";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    audacity
    bacon
    bat
    cargo-expand
    cargo-nextest
    customPkgs.cargo-bisect-rustc
    discord
    fzf
    gcc
    gh
    git-absorb
    git-crypt
    htop
    inferno
    jetbrains.idea-ultimate
    linuxKernel.packages.linux_6_1.perf
    mold # For global .cargo/config.toml
    nixpkgs-fmt
    obsidian
    obs-studio
    postman
    prismlauncher
    python3
    ripgrep
    rnix-lsp
    rustup-toolchain-install-master
    spotify
  ];

  programs.home-manager.enable = true;

  programs.git = import ./git.nix { inherit pkgs; };
  programs.firefox = import ./firefox.nix { inherit pkgs; };
  programs.vscode = import ./vscode.nix { inherit pkgs; };

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
