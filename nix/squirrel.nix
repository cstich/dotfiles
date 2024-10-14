# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  hostname = "squirrel";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./common/common.nix
      ./common/neovim.nix
      ./common/fonts.nix
      ./common/gnome.nix
      ./common/syncthing.nix
      ./common/shell.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Brother scanner support
  hardware.sane = {
    enable = true;
    brscan4.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  sound.enable = true;
  networking ={
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
    hostName = hostname; 
    extraHosts = "127.0.1.1 squirrel";
    networkmanager.enable = true; 
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };


  # My  gnome3 config
  myGnome3.gdm.enable = true;
  myGnome3.wayland.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  users.users.christoph = {
    isNormalUser = true;
    home = "/home/christoph";
    extraGroups = [ "netdev" "audio" "colord" "networkManager" "wheel" "scanner" "lp"]; 
    shell = pkgs.fish;
    packages = with pkgs; [

    ];
  };

  system.stateVersion = "20.09"; # Do not change 
} 
