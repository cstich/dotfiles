# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  hostname = "lion";
in

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./common/common.nix
      ./common/neovim.nix
      ./common/helix.nix
      ./common/fonts.nix
      ./common/gnome.nix
      ./common/shell.nix
    ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  nixpkgs.config.allowUnfree = true;
  # virtualisation.virtualbox.guest.enable = false;
  virtualisation.docker.enable = true;

  networking = {
    hostName = hostname; # Define your hostname.
    # Create a self-resolving hostname entry in /etc/hosts
    extraHosts = "127.0.0.1 lion";
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # My gnome3 config
  myGnome.gdm.enable = true;
  myGnome.lightdm.enable = false;
  myGnome.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.displayManager.xserverArgs = [
    "-maxbigreqsize 127"
    "-nolisten tcp"
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  users.users.christoph = {
    isNormalUser = true;
  home = "/home/christoph";
    extraGroups = [ "audio" "docker" "networkManager" "wheel" "scanner" "lp" "vboxsf" ]; 
    subUidRanges = [{ startUid = 100000; count = 65536; }]; # for podman
    subGidRanges = [{ startGid = 100000; count = 65536; }]; # for podman
  };

  system.stateVersion = "22.05"; # Do not change 
} 
