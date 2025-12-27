{ pkgs, ... }: {
  imports = [
    ./home.nix
  ];

  home.packages = with pkgs; [ krita ];

  is-laptop = true;
}
