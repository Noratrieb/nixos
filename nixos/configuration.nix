# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.nur.overlay
      # final: prev: {
      #  curl = prev.curl.override {
      #    # vquic is sad right now.
      #    # http3Support = true;
      #  };
      # )
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      nvidia.acceptLicense = true;
      # allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    extraHosts =
      ''
        192.168.122.44 illumos-vm
      '';
  };

  time.timeZone = "Europe/Zurich";
  # Windows sets the hardware clock in local time by default.
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    minegrub-theme = {
      enable = true;
      # splash = ":3";
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.wallpaper.mode = "fill";
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
      extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
    };

    # Configure keymap in X11
    layout = "ch";
    xkbVariant = "";

    # ndivia drivers
    videoDrivers = [ "nvidia" ];

    # mouse settings
    # https://unix.stackexchange.com/questions/58900/how-to-scroll-the-screen-using-the-middle-click
    #libinput.mouse = {
    #  scrollMethod = "button";
    #  # 2=middle mouse button
    #  scrollButton = 2;
    #};
  };

  hardware.opengl.enable = true;

  # TODO: Create a fancontrol config
  hardware.fancontrol.enable = false;
  hardware.fancontrol.config = ''
  '';

  console.keyMap = "sg";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;


    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users = {
    users = {
      nils = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0n1ikUG9rYqobh7WpAyXrqZqxQoQ2zNJrFPj12gTpP"
        ];
        extraGroups = [ "wheel" "networkmanager" "audio" "libvirtd" ];
        packages = with pkgs; [
          vscode
        ];
        shell = pkgs.fish;
      };
    };
    extraGroups = {
      vboxusers = {
        members = [ "nils" ];
      };
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };


  environment.systemPackages = with pkgs; [
    vim
    wget
    (curl.override {
      # error: implicit declaration of function 'SSL_set_quic_use_legacy_codepoint' :(
      # http3Support = true;
      # curl: (60) rustls_connection_process_new_packets: invalid peer certificate: BadSignature :(
      # opensslSupport = false;
      # rustlsSupport = true;
    })
    firefox
    os-prober
    git
    fish
    (steam.override {
      extraPkgs = pkgs: [ bumblebee glxinfo ];
    }).run
    # Wine for 32 and 64 bit applications
    wineWowPackages.stable
    virt-manager
    podman
    neofetch # for the grub theme
    podman-compose
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };

  programs.fish = {
    enable = true;
  };

  programs.java.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  hardware.enableAllFirmware = true;

  hardware.openrazer.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
