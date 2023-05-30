{config, lib, pkgs, ...}:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  cfg = config.myGnome3;
in

{

  imports = [
  ];

  options = {
    myGnome3 = {
      lightdm.enable = lib.mkEnableOption "lightdm";
      gdm.enable = lib.mkEnableOption "gdm";
      wayland.enable = lib.mkEnableOption "wayland";
   };
  };

  config = {
 
    environment.systemPackages = with pkgs; [

       # Gnome things
       gnome.gnome-tweaks
       gnome.dconf-editor
       gnome.gedit
       gnome.gnome-session
       gnome.gnome-terminal
       gnome.networkmanager-openvpn
       gnome.networkmanager-openvpn
       gnome.seahorse

       gnomeExtensions.switcher
       gnomeExtensions.vertical-overview
      
       arc-theme
       arc-icon-theme
       materia-theme
       lxappearance
       pantheon.elementary-icon-theme
       
       # Deskotp things
       unstable.alacritty
       dconf
       discord
       firefox
       google-chrome
       gparted
       git-filter-repo
       rofi
       ulauncher
       discord
       kitty
       lapce
       libreoffice
       meld
       unstable.onedrive
       pass
       peek
       qtpass
       skypeforlinux
       transmission-gtk
       virtualbox
       veracrypt
       vscode-fhs
       vlc
       unstable.wezterm
       unstable.displaycal

       # Eclipse clipboard only works with thunar
       xfce.thunar
 
       # Sound settings
       pavucontrol 

       # Nix things
       direnv
       nix-direnv

       # Styling of QT 5 apps
       libsForQt5.qtstyleplugins
       libsForQt5.qtstyleplugin-kvantum 
       qt5ct
      
       # RDP client
       remmina
      ];
      
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      layout = "us";
      # xkbOptions = "eurosign:e";
      # Enable touchpad support.
      libinput.enable = true;

      desktopManager = {
        gnome.enable = true;
      };

      displayManager = {
        lightdm.enable = cfg.lightdm.enable;
        gdm.enable = cfg.gdm.enable;
        gdm.wayland = cfg.wayland.enable;
      }; 
    };
 
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Steam is a funny program to install
    # TODO This currently fails; open issue
    programs.steam.enable = true; 

    # Allow flatpaks
    services.flatpak.enable = true;

    services.gvfs.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ]; 
    services.gnome = {
      gnome-online-accounts.enable = true;
      gnome-keyring.enable = true;
      core-os-services.enable = true;
      gnome-settings-daemon.enable = true;
      sushi.enable = true;
      # tracker.enable = true;
      # tracker-miners.enable = true;
    }; 

    services.xserver.wacom.enable = true;

    # Nix-direnv config
    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];
    };
}
