# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  hostname = "marmot";
in

{
  # nix.package = pkgs.nixUnstable;
  imports =
    [ 
      <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
      # Include the results of the hardware scan.
      # ./hardware-configuration.nix
      /etc/nixos/hardware-configuration.nix
      ./common/dropbox.nix
      ./common/zsh.nix
      ./common/fonts.nix
    ];

  # TODO Factor out marmot specific settings
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.useOSProber = true;
  # Virtualization settings
  boot.kernelModules = [ "kvm-amd" "kvm-intel"];
  virtualisation.libvirtd.enable = true;
  # boot.plymouth.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WDS500G2B0B-00YS70_2021DB462501"; # or "nodev" for efi only

  # Tell initrd to unlock LUKS on /dev/sda2
  boot.initrd.luks.devices = {
    crypted = { 
       device = "/dev/disk/by-uuid/61bca8b2-fc40-48e1-b73a-c7e604e556be"; 
       preLVM = true; 
       allowDiscards = true; 
    };
    # luks-c47b1559-11f9-4713-a02e-77852338ba45 = {
    #    device = "/dev/disk/by-uuid/c47b1559-11f9-4713-a02e-77852338ba45";
    #    preLVM = true;
    #    allowDiscards = true;
    # };
  };

  boot.initrd.luks.reusePassphrases = true;
  # FIXME This does not work for whatever reason
  # boot.initrd.luks.devices = {
  #   m2 = {
  #     device = "/dev/disk/by-uuid/c47b1559-11f9-4713-a02e-77852338ba45";
  #     preLVM = true;
  #     allowDiscards = true;
  #   };
  # };

  # Brother scanner
  hardware.sane = {
    enable = true;
    brscan4.enable = true;
  };


  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraConfig = ''
      # Automatically switch to newly connected devices.
      # load-module module-switch-on-connect
      # Discover Apple iTunes devices on network.
      load-module module-raop-discover
    '';
    zeroconf.discovery.enable = true;

    # Enable extra bluetooth modules, like APT-X codec.
    extraModules = [ pkgs.pulseaudio-modules-bt ];

    # Enable bluetooth (among others) in Pulseaudio
    package = pkgs.pulseaudioFull;
  };
  networking = {
    hostName = hostname; # Define your hostname.
    # Create a self-resolving hostname entry in /etc/hosts
    extraHosts = "127.0.1.1 marmot";
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };
  # Select internationalisation properties.
  console = {
     font = "Lat2-Terminus16";
     # keyMap = "us";
     useXkbConfig = true;
  };
  i18n = {
     # consoleFont = "FuraCode Nerd Font Mono";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnfree = true;
 
  environment.systemPackages = let 
    # Specify which pacakges are available to the global python interpreter
    myPythonPackages = pythonPackages: with pythonPackages; []; 
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  in with pkgs; [
     # Terminal applications
     ag
     dnsutils 
     ldns
     nox
     exa
     dmidecode
     feh
     fzf
     htop
     killall
     ncat
     neofetch
     ncdu
     nethogs
     (python3.withPackages myPythonPackages)
     powerline-go
     neovim
     pass
     qtpass
     tmux
     qemu_kvm
     wirelesstools
     wget
     which
     zathura
     zip
     
     # Git things
     git
     bfg-repo-cleaner
     git-lfs

     # Gnome things
     gnomeExtensions.appindicator
     gnome3.dconf
     gnome3.gnome-tweaks
     gnome3.dconf-editor
     gnome3.gnome-session
     gnome3.networkmanager-openvpn
     gnome3.seahorse
     gnomeExtensions.appindicator

     lightdm

     # neovim dependencies
     yarn
     nodejs

     # Nix things
     direnv
     nix-direnv
     any-nix-shell
     nix-index
     nixpkgs-review
     binutils-unwrapped
     patchelf
     nix-prefetch-git  # Gets you the sha256 of github packages

     # Sound settings
     pavucontrol
     
     # Git fork of compton the composition manager for X
     compton-git

     discord
     unstable.vscode 
     firefox
     google-chrome
     gparted
     notify-desktop
     signal-desktop    
     rofi
     gimp
     inkscape
     ntfs3g
     unstable.woeusb
     virt-manager
     google-play-music-desktop-player

     steam
     steam-run
     libreoffice
     veracrypt
     
     arc-theme
     arc-icon-theme
     materia-theme
     lxappearance
    
     pantheon.elementary-icon-theme

     lm_sensors
     gsmartcontrol

     # Styling of QT 5 apps
     libsForQt5.qtstyleplugins
     libsForQt5.qtstyleplugin-kvantum 
     qt5ct
  ] 
  ++ lib.optionals config.services.samba.enable [ kdenetwork-filesharing pkgs.samba ];


  environment.pathsToLink = [
    # FIXME: modules should link subdirs of `/share` rather than relying on this
    "/share"
    "/share/nix-direnv"
  ];
  
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  services.flatpak.enable = true;
  
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
  };

  services.sshguard = {
    enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # xkbOptions = "eurosign:e";
    videoDrivers = [ "nvidia" ];
    # xkbOptions = "caps:swapescape";
    # Enable touchpad support.
    libinput.enable = true;

    desktopManager = {
      gnome3.enable = true;
    };
    displayManager = {
      gdm.enable = true;
      autoLogin.enable = false;
      autoLogin.user = "christoph";
      gdm.wayland = false;
    };
  };
  
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

  services.xserver.displayManager.sessionCommands = ''
    # Fix QT config app
    export QT_QPA_PLATFORMTHEME=qt5ct
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.christoph = {
     isNormalUser = true;
     home = "/home/christoph";
     description = "Christoph Stich";
     extraGroups = ["audio" "wheel" "networkManager" "scanner" "lp"];
     uid = 1000;
     shell = pkgs.zsh;
     openssh.authorizedKeys.keyFiles = ["/home/christoph/Secrets/authorized_keys"];
   };


  virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "christoph" ];

  # Services below here
  location.longitude = 1.8904;
  location.latitude = 51.4862;

  services.redshift.enable = true;
  services.gvfs.enable = true;
  # security.pam.services.lightdm.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ]; 
  services.gnome3 = {
    gnome-online-accounts.enable = true;
    gnome-keyring.enable = true;
    core-os-services.enable = true;
    gnome-settings-daemon.enable = true;
    sushi.enable = true;
    # tracker.enable = true;
    # tracker-miners.enable = true;
  };


  nix = {
    autoOptimiseStore = true;
  };  

  # powerManagement.resumeCommands = ''
  #   # CUDA suspend crash fix
  #   nvidia-smi -pm ENABLED
  #   nvidia-smi -c EXCLUSIVE_PROCESS
  #   # TODO Add here the rmmode modprobe suspend CUDA fix
  #   rmmod nvidia_uvm
  #   modprobe nvidia_uvm
  # ''; 

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;
  services.printing.drivers = [pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];

  # Auto upgrades of packages from time to time
  system.autoUpgrade.enable = true;
  
  # Automated weekly garbage collection
  nix.gc = {
    automatic = false;
    dates = "weekly";
    options = "--delete-older-than 90d";
  };

  # Allow parallel builds
  nix.maxJobs = 4;
  nix.buildCores = 4;

  # Deactivate the sandbox as julia does not build with the sandbox enabled
  nix.useSandbox = false;

  services.nscd.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

}
