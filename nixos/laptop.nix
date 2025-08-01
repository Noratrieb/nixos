{ ... }: {
  imports = [
    ./configuration.nix
  ];

  networking = {
    hostName = "scrap";
  };

  boot.loader.systemd-boot.enable = true;
}
