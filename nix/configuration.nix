# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # nix.package = pkgs.nixUnstable;
  imports =
    [ 
      <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include the zsh configuration
      # ./zsh.nix
    ];

  # TODO Factor out marmot specific settings
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.plymouth.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.grub.extraEntries = ''
    menuentry "Windows 10" {
    insmod part_msdos
    insmod ntldr
    insmod ntfs
    insmod search_fs_uuid
    search --no-floppy --fs-uuid --set=root 48E46FFFE46FEE1E
    ntldr /bootmgr
    }
  '';

  # Tell initrd to unlock LUKS on /dev/sda2
  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices = {
    crypted = { 
       device = "/dev/sda2"; 
       preLVM = true; 
       allowDiscards = true; 
    };
    # m2 = {
    #   device = "/dev/nvme0n1";
    #   preLVM = true;
    #   allowDiscards = true;
    # };
  };

  hardware.sane.enable = true;
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
    hostName = "marmot"; # Define your hostname.
    # Create a self-resolving hostname entry in /etc/hosts
    extraHosts = "127.0.1.1 nix-pc";
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
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnfree = true;
 
  environment.systemPackages = let 
  # Specify which pacakges are available to the global python interpreter
  myPythonPackages = pythonPackages: with pythonPackages; [
  ]; 
  in with pkgs; [
     # Terminal applications
     ag
     # busybox
     nox
     exa
     dmidecode
     feh
     fzf
     htop
     killall
     neofetch
     ncdu
     nethogs
     (python3.withPackages myPythonPackages)
     powerline-go
     neovim
     pass
     qtpass
     tmux
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
     gnome3.gnome-tweaks
     gnome3.dconf-editor
     gnome3.gnome-session
     gnome3.seahorse

     # neovim dependencies
     yarn
     nodejs

     # Nix things
     direnv
     any-nix-shell
     nix-index
     binutils-unwrapped
     patchelf

     # Sound settings
     pavucontrol
     
     # Git fork of compton the composition manager for X
     compton-git

     firefox
     signal-desktop    
     rofi
     gimp
     dropbox
     dropbox-cli
     # google-play-music-desktop-player

     libreoffice
     veracrypt
     
     arc-theme
     arc-icon-theme
     materia-theme
     # flat-remix-icon-theme
     lxappearance
    
     pantheon.elementary-icon-theme

     lm_sensors

     # Styling of QT 5 apps
     libsForQt5.qtstyleplugins
     libsForQt5.qtstyleplugin-kvantum 
     qt5ct
     
     # Nixos relevant packages
     # Gets you the sha256 of github packages
     nix-prefetch-git

     # Printer drivers for Brother printers (do not know which one I need)
     brlaser
     brscan4
     brgenml1lpr 
     brgenml1cupswrapper

  ] 
  ++ lib.optionals config.services.samba.enable [ kdenetwork-filesharing pkgs.samba ];


  environment.pathsToLink = [
    # FIXME: modules should link subdirs of `/share` rather than relying on this
    "/share"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
      gdm.autoLogin.enable = false;
      gdm.autoLogin.user = "christoph";
      gdm.wayland=false;
    };
  };
  
  # Deactivate the annoying ssh passphrase popup
  # programs.ssh = {
  #   askPassword = "";
  # };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins= ["git" "pass" "ssh-agent"];
    syntaxHighlighting.enable = true;
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
     extraGroups = ["audio" "wheel" "networkManager" ];
     uid = 1000;
     shell = pkgs.zsh;
     openssh.authorizedKeys.keyFiles = ["/home/christoph/Secrets/authorized_keys"];
   };

# Setup font rendering
 fonts = {
  enableDefaultFonts = true;
  fonts = with pkgs; [
    xorg.fontbh100dpi
    xorg.fontmiscmisc
    xorg.fontcursormisc
    ubuntu_font_family
    powerline-fonts
    corefonts 
    liberation_ttf
    overpass
    siji 
    fira
    nerdfonts
    source-code-pro
    source-sans-pro
    source-serif-pro
    roboto-slab
  ];
  fontconfig = {
    hinting.autohint = true;
    useEmbeddedBitmaps = true;
    defaultFonts.serif = ["Source Serif Pro"];
    defaultFonts.sansSerif = [ "Fira Sans" ];
    defaultFonts.monospace = [ "FuraCode Nerd Font Mono" ];
  };
};

  # Services below here
  location.longitude = 1.8904;
  location.latitude = 51.4862;

  # services.redshift.enable = true;
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
    # nixPath = [
    #   "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    #   "nixos-config=/home/christoph/Projects/dotfiles/nix/configuration.nix"
    #   "/nix/var/nix/profiles/per-user/root/channels"
    # ];
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

  # Auto upgrades of packages from time to time
  system.autoUpgrade.enable = true;
  
  # Automated weekly garbage collection
  nix.gc = {
    automatic = true;
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
  system.stateVersion = "20.03"; # Did you read the comment?

}
