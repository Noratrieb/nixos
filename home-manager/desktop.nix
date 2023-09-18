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
    ./common.nix
    ./git.nix
    ./firefox.nix
    ./vscode.nix
  ];

  home = {
    username = "nils";
    homeDirectory = "/home/nils";
  };

  home.packages = with pkgs; [
    audacity
    customPkgs.cargo-bisect-rustc
    discord
    jetbrains.idea-ultimate
    linuxKernel.packages.linux_6_1.perf
    obs-studio
    obsidian
    postman
    prismlauncher
    spotify
  ] ++ import ./common-packages.nix { inherit pkgs; };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}