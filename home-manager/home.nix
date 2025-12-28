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
    ./swaync.nix
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

  services.playerctld.enable = true;

  home.packages = with pkgs; [
    audacity
    customPkgs.cargo-bisect-rustc
    customPkgs.run
    customPkgs.unpem
    discord
    obsidian
    prismlauncher
    spotify
    libreoffice
    rustup # rustup from nix for rust :)
    gamescope # so i can put it in steam startup command lines
    wl-clipboard
    (pkgs.writeShellApplication {
      name = "lock-and-power-off-screen";
      text = ''
        niri msg action power-off-monitors
        exec swaylock
      '';
    })
    (pkgs.writeShellApplication {
      name = "shell.nix";
      text = ''
        cat > shell.nix <<EOF
        { pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
          buildInputs = with pkgs; [ ];
          packages = with pkgs; [ ];
        }
        EOF

        echo "use nix" > .envrc
      '';
    })
  ] ++ import ./common-packages.nix { inherit pkgs inputs; };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
