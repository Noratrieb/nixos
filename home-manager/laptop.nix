{ inputs, pkgs, ... }: {
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
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = import ./common-packages.nix { inherit pkgs; };

  programs.fish.interactiveShellInit = ''
    set fish_greeting # Disable greeting
    . /home/nilsh/.nix-profile/etc/profile.d/nix.fish
  '';

  home = {
    username = "nilsh";
    homeDirectory = "/home/nilsh";
  };
}