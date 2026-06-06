{ pkgs, config, ... }: {
  imports = [
    ./desktop-hardware-configuration.nix
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

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

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

  programs.coolercontrol.enable = true;

  # it would be cool if this didnt use up so many different ports...
  # maybe a network namespace and bridge or something??
  # unix sockets dont appear to be supported sadly
  services.victoriametrics.enable = true;
  services.vmagent = {
    enable = true;
    remoteWrite.url = "http://127.0.0.1:8428/api/v1/write";
    prometheusConfig = {
      scrape_configs = [
        {
          job_name = "node-exporter";
          static_configs = [{ targets = [ "127.0.0.1:9100" ]; }];
        }
        {
          job_name = "cadvisor";
          static_configs = [{ targets = [ "127.0.0.1:8080" ]; }];
        }
        {
          job_name = "systemd";
          static_configs = [{ targets = [ "127.0.0.1:9558" ]; }];
        }
        {
          job_name = "coolercontrol";
          authorization = {
            type = "Bearer";
            credentials = "cc_5fed8f3b7bd44424b7ffc67cce940e55";
          };
          static_configs = [{ targets = [ "127.0.0.1:11987" ]; }];
        }
      ];
    };
  };
  services.prometheus.exporters = {
    node.enable = true;
    systemd.enable = true;
  };
  services.cadvisor = {
    enable = true;
    extraOptions = [
      # significantly decreases CPU usage (https://github.com/google/cadvisor/issues/2523)
      "--housekeeping_interval=30s"
    ];
  };
  services.grafana = {
    enable = true;

    settings = {
      security = {
        # here are my secrets, use them while they're hot
        admin_user = "admin";
        admin_password = "admin";
        secret_key = "SW2YcwTIb9zpOOhoPsMm";
      };
      server.http_port = 4444;
    };

    declarativePlugins = [
      pkgs.grafanaPlugins.victoriametrics-metrics-datasource
    ];

    provision = {
      enable = true;
      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "victoriametrics";
            type = "victoriametrics-metrics-datasource";
            access = "proxy";
            url = "http://127.0.0.1:8428";
          }
        ];
      };
    };
  };

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
    usbutils # steam client logs complain about lsusb
    kdiskmark
  ];

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [
      /*SSH*/
      22
      11434
    ];

    # https://github.com/tailscale/tailscale/issues/4432#issuecomment-1112819111
    checkReversePath = "loose";
  };

  # TODO: ENABLE NVIDIA DRIVERS WHEN THEY STOP BEING READY
  #hardware.nvidia-container-toolkit.enable = true;

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
