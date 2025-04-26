# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs
, inputs
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
    ./common.nix
    ./git.nix
    ./firefox.nix
    ./vscode.nix
    ./waybar.nix
    ./swaylock.nix
  ];

  home = {
    username = "nora";
    homeDirectory = "/home/nora";
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
  };

  programs.niri = {
    config = builtins.readFile ./config.kdl;
  };
  services.gnome-keyring.enable = true;

  home.packages = with pkgs; [
    audacity
    customPkgs.cargo-bisect-rustc
    customPkgs.run
    customPkgs.unpem
    discord
    jetbrains.idea-ultimate
    obsidian
    prismlauncher
    spotify
    # rustup from nix for rust :)
    rustup
  ] ++ import ./common-packages.nix { inherit pkgs inputs; };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
