{pkgs, ...}:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in

{
  environment.systemPackages = with pkgs; [

     # Gnome things
     gnome.dconf
     gnome.gnome-tweaks
     gnome.dconf-editor
     gnome.gnome-session
     gnome.meld
     gnome.networkmanager-openvpn
     gnome.seahorse
     gnomeExtensions.appindicator
     gnomeExtensions.material-shell

     arc-theme
     arc-icon-theme
     materia-theme
     lxappearance
     pantheon.elementary-icon-theme
     
     # Deskotp things
     google-chrome
     discord
     firefox
     rofi
     discord
     skype
     steam-run
     libreoffice
     pass
     peek
     qtpass
     transmission-gtk
     veracrypt
     wireguard

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
      gdm.enable = true;
      autoLogin.enable = false;
      autoLogin.user = "christoph";
      gdm.wayland = false;
    };
  };
 
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

 
  # Steam is a funny program to install
  programs.steam.enable = true; 

  # Services
  services.redshift.enable = true;
  location.longitude = 1.8904;
  location.latitude = 51.4862;

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

  services.xserver.displayManager.sessionCommands = ''
    # Fix QT config app
    export QT_QPA_PLATFORMTHEME=qt5ct
  '';

  # Nix-direnv config
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];
}
