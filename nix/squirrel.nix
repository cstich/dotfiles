# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  hostname = "squirrel";
in

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./common/common.nix
      ./common/fonts.nix
      ./common/gnome.nix
      ./common/syncthing.nix
      ./common/zsh.nix

<nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Brother scanner support
  hardware.sane = {
    enable = true;
    brscan4.enable = true;
  };

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/a499cdc8-79a3-46b6-80b7-fdaef2c8d7d7";
      preLVM = true;
      allowDiscards = true;
    };
    crypt-data = {
      device = "/dev/disk/by-uuid/d654f007-3385-4a2e-927f-60b88c892bcb";
      preLVM = true;
      allowDiscards = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  networking ={
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    hostName = hostname; 
    extraHosts = "127.0.1.1 squirrel";
    networkmanager.enable = true; 
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # My  gnome3 config
  myGnome3.gdm.enable = true;

 # Configure keymap in X11
  services.xserver.layout = "us";

  users.users.christoph = {
    isNormalUser = true;
    home = "/home/christoph";
    extraGroups = [ "audio" "networkManager" "wheel" "scanner" "lp"]; 
    shell = pkgs.zsh;
  };

  system.stateVersion = "20.09"; # Do not change 
} 
