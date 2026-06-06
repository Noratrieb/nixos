# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs
, inputs
, lib
, ...
}:
let
  customPkgs = import ../custom-pkgs/default.nix pkgs;
  fuzzel-launch-prefix = (pkgs.writeShellApplication {
    name = "fuzzel-launch-prefix";
    text = ''
      name=$(basename "$1")

      # https://stackoverflow.com/questions/13043344/search-and-replace-in-bash-using-regular-expressions
      # https://github.com/niri-wm/niri/blob/f717ae030fe56fc52522ebef69f17f3f09064ac4/src/utils/spawning.rs#L429
      re='(.*)[^a-zA-Z0-9:_\.]+(.*)'
      while [[ $name =~ $re ]]; do
        # niri doesn't just yeet it out but encode it but that's too complicated for us
        name="$${BASH_REMATCH[1]}$${BASH_REMATCH[2]}"
      done

      exec systemd-run --scope --user --unit "app-$name" "$@"
    '';
  });
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
    ./wallpaper.nix
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
    customPkgs.flash-glove80
    discord
    obsidian
    prismlauncher
    spotify
    libreoffice
    rustup # rustup from nix for rust :)
    gamescope # so i can put it in steam startup command lines
    wl-clipboard
    (olympus.override {
      celesteWrapper = "steam-run";
    })
    archipelago
    (pkgs.writeShellApplication {
      name = "lock-and-power-off-screen";
      text = ''
        niri msg action power-off-monitors
        exec swaylock
      '';
    })
    (pkgs.writeShellApplication {
      name = "fuzzel-in-niri";
      text = ''
        ${lib.getExe pkgs.fuzzel} --launch-prefix "${lib.getExe fuzzel-launch-prefix}"
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
