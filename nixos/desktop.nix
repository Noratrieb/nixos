{ pkgs, config, ... }: {
  imports = [
    ./desktop-hardware-configuration.nix
    ./paperless.nix
    ./configuration.nix
  ];

  networking = {
    hostName = "nixos";
    extraHosts =
      ''
        192.168.122.44 illumos-vm
      '';
  };

  # Windows sets the hardware clock in local time by default.
  time.hardwareClockInLocalTime = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    minegrub-theme = {
      enable = true;
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/mnt/nas" = {
    device = "192.168.178.47:/volume1/homes";
    fsType = "nfs";
  };

  services.xserver = {
    # ndivia drivers
    # long story short night light mode is currently broken with nvidia drivers. LMAO
    # - https://forums.developer.nvidia.com/t/screen-freezes-at-random-intervals-with-rtx-4060-max-q-mobile-multiple-driver-versions-tested/295811/6?u=mirao
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    # https://github.com/NixOS/nixpkgs/issues/299944#issuecomment-2027246826
    modesetting.enable = true;
    open = true;
  };

  programs.coolercontrol.nvidiaSupport = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        # P256
        path = "/etc/ssh/ssh_host_ecdsa_key";
        type = "ecdsa";
      }
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
    ];
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  environment.systemPackages = with pkgs; [
    tailscale
    os-prober
  ];

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ /*SSH*/ 22 ];

    # https://github.com/tailscale/tailscale/issues/4432#issuecomment-1112819111
    checkReversePath = "loose";
  };

  networking.interfaces.enp39s0.wakeOnLan.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
