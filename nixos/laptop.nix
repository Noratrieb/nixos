{ ... }: {
  imports = [
    ./configuration.nix
  ];

  networking = {
    hostName = "scrap";
  };

  boot.loader.systemd-boot.enable = true;

  syste.stateVersion = "25.11";
}
