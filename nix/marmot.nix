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
      # Custom modules
      ./common/common.nix
      ./common/dropbox.nix
      ./common/zsh.nix
      ./common/fonts.nix
      ./common/gnome.nix
      ./common/syncthing.nix
    ];

  # TODO Factor out marmot specific settings
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_10.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
            sha256 = "1iyw3nmsga2binmrhfnzsf1pvn2bs21a8jw6vm89k26z5h8zfgkh";
      };
      version = "5.10.117";
      modDirVersion = "5.10.117";
      };
  });

  # TODO Suspend bug introduced in 5.10.113. Add pm_trace flag
  # boot = {
  #   kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_10.override {
  #     argsOverride = rec {
  #       src = pkgs.fetchurl {
  #             url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
  #             sha256 = "0w9gwizyqjgsj93dqqvlh6bqkmpzjajhj09319nqncc95yrigr7m";
  #       };
  #       version = "5.10.115";
  #       modDirVersion = "5.10.115";
  #       structuredExtraConfig = with pkgs.lib.kernel; {
  #           PM_DEBUG = yes;
  #           PM_TRACE_RTC = pkgs.lib.mkForce yes;
  #         };
  #       ignoreConfigErrors = true;
  #       };
  #   });
  # };

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
  # FIXME This does not work for whatever reason. Make sure the correct paths are set in hardware.nix
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

  networking.useDHCP = false;
  networking.interfaces.enp70s0.useDHCP = true;

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
  myGnome3.gdm.enable = true;
 
  environment.systemPackages = let 
    # Specify which pacakges are available to the global python interpreter
    myPythonPackages = pythonPackages: with pythonPackages; []; 
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  in with pkgs; [
     # Terminal applications
     dnsutils 
     ldns
     nox
     dmidecode
     feh
     killall
     ncat
     neofetch
     ncdu
     nethogs
     (python3.withPackages myPythonPackages)
 
     tmux
     qemu_kvm
     wirelesstools
     zathura
     
     # Git things
     bfg-repo-cleaner
     git-lfs

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

    # Git fork of compton the composition manager for X
     compton-git

     discord
     unstable.vscode 
     google-chrome
     gparted
     notify-desktop
     signal-desktop    
     gimp
     inkscape
     ntfs3g
     woeusb
     virt-manager
     google-play-music-desktop-player

     lm_sensors
     gsmartcontrol

  ] 
  ++ lib.optionals config.services.samba.enable [ kdenetwork-filesharing pkgs.samba ];
  
  # List services that you want to enable:
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
  };

  services.sshguard = {
    enable = true;
  };

  # hardware.pulseaudio.extraConfig = "pactl set-card-profile alsa_card.usb-Generic_USB_Audio-00 HiFi";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.christoph = {
     isNormalUser = true;
     home = "/home/christoph";
     description = "Christoph Stich";
     extraGroups = ["audio" "wheel" "networkManager" "scanner" "lp"];
     uid = 1000;
     shell = pkgs.zsh;
     openssh.authorizedKeys.keyFiles = ["/home/christoph/Secrets/authorized_keys" "/home/christoph/Secrets/hrc-calc-pub"];
  }; 

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "christoph" ];
 
  # Add nvidia drivers for Marmot
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;
  services.printing.drivers = [pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];

  # Allow parallel builds
  nix.maxJobs = 4;
  nix.buildCores = 40;

  # Deactivate the sandbox as julia does not build with the sandbox enabled
  nix.useSandbox = false;

  services.nscd.enable = true; 

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

}
