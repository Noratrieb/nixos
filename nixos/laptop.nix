{ ... }: {
  imports = [
    ./laptop-hardware-configuration.nix
    ./configuration.nix
  ];

  networking = {
    hostName = "scrap";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}
