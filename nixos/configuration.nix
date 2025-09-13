# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }:
let
  customPkgs = import ../custom-pkgs/default.nix pkgs;
in
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    inputs.niri.nixosModules.niri
  ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.nur.overlays.default
      inputs.niri.overlays.niri
      # final: prev: {
      #  curl = prev.curl.override {
      #    # vquic is sad right now.
      #    # http3Support = true;
      #  };
      # )
    ];
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
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

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";

  i18n.defaultLocale = "en_US.UTF-8";

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;

  boot.binfmt = {
    emulatedSystems = [ "wasm32-wasi" "aarch64-linux" ];
    preferStaticEmulators = true; # required to work with podman (apparently)
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    # 100 seems to be a good value for SSDs https://chrisdown.name/2018/01/02/in-defence-of-swap.html,
    # as anon and file pages are equally expensive so 100 balances them out.
    "vm.swappiness" = 100;
    # 340 is 0x154, which enables Rqs
    # - n (denice RT tasks)
    # - e (SIGTERM everyone but PID 1)
    # - i (same but SIGKILL)
    # - f (hallucinate OOM and kill one unlucky motherfucker)
    # - s (Sync Em All 1989)
    # - k (ghetto Ctrl+Alt+Del-to-log-in)
    # - r (unraw)
    "kernel.sysrq" = 340;
  };

  # Enable the Wayland windowing system.
  services.displayManager.gdm.enable = true;
  services.desktopManager = {
    gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
      extraGSettingsOverridePackages = [ pkgs.mutter ];
    };
  };
  services.xserver = {
    enable = true;
    desktopManager.wallpaper.mode = "fill";

    # Configure keymap in X11
    xkb = {
      layout = "ch";
      variant = "";
    };

    # mouse settings
    # https://unix.stackexchange.com/questions/58900/how-to-scroll-the-screen-using-the-middle-click
    #libinput.mouse = {
    #  scrollMethod = "button";
    #  # 2=middle mouse button
    #  scrollButton = 2;
    #};
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
  };

  niri-flake.cache.enable = false;
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  services.displayManager.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome pkgs.gnome-keyring ];
  services.gnome = {
    gcr-ssh-agent.enable = true;
  };
  programs.waybar.enable = true;

  services.flatpak.enable = true;

  console.keyMap = "sg";

  # do you even print bro? have you ever printed bro? don't cups me bro.
  services.printing.enable = false;

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    # as soon as it starts swapping its SO over (hm)
    freeSwapThreshold = 90;
  };

  # Shows notification for `net.nuetzlich.SystemNotifications.Notify` D-Bus messages
  services.systembus-notify.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  fonts.packages = with pkgs; [ fira-code customPkgs.monaspace ];

  services.nixseparatedebuginfod.enable = true;

  users = {
    users = {
      nora = {
        uid = 1000;
        isNormalUser = true;
        home = "/home/nora";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0n1ikUG9rYqobh7WpAyXrqZqxQoQ2zNJrFPj12gTpP"
        ];
        extraGroups = [ "wheel" "networkmanager" "audio" "libvirtd" "docker" ];
        packages = with pkgs; [
          vscode
          chromium
        ];
        shell = pkgs.fish;
      };
    };
    extraGroups = {
      vboxusers = {
        members = [ "nora" ];
      };
    };
  };

  systemd.user = {
    services.regenerate-bsod-lockscreen = {
      description = "Regenerate the lock screen image";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe (import ./bsod { inherit pkgs lib; });
      };
    };
    timers.regenerate-bsod-lockscreen = {
      description = "Regenerate the lock screen image";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "regenerate-bsod-lockscreen.service";
        OnBootSec = "10s";
        OnUnitActiveSec = "60s";
        AccuracySec = "5s";
      };
    };
  };

  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };
  # This is apparently used by Electron? Maybe not anymore.
  environment.sessionVariables.DEFAULT_BROWSER = lib.getExe pkgs.firefox;

  environment.enableDebugInfo = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    # for firefox-nightly
    # inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    firefox
    git
    (linuxKernel.packagesFor linuxKernel.kernels.linux_latest).perf
    fish
    unzip
    (steam.override {
      extraPkgs = pkgs: [ glxinfo ];
    }).run
    # Wine for 32 and 64 bit applications
    wineWowPackages.stable
    virt-manager
    podman
    neofetch # for the grub theme
    fastfetch
    podman-compose
    man-pages
    man-pages-posix
    bpftrace
    file
    comma
    alacritty
    fuzzel
    xwayland-satellite
    font-awesome
    mpv
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
    libvirtd = {
      enable = true;
      qemu = {
        # enable TPM emulation
        swtpm.enable = true;
      };
    };
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker.enable = true;
    virtualbox.host = {
      enable = true;
    };
  };

  hardware.enableAllFirmware = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
  };

  system.nixos.distroName = "🏳️‍⚧️";
}
