{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [

     # Gnome things
     gnomeExtensions.appindicator
     gnome3.dconf
     gnome3.gnome-tweaks
     gnome3.dconf-editor
     gnome3.gnome-session
     gnome3.networkmanager-openvpn
     gnome3.seahorse
     gnomeExtensions.appindicator

     arc-theme
     arc-icon-theme
     materia-theme
     lxappearance
     pantheon.elementary-icon-theme
     
     # Deskotp things
     firefox
     rofi
     discord
     skype
     steam
     steam-run
     libreoffice
     pass
     qtpass
     veracrypt
     zoom-us
 
     # Sound settings
     pavucontrol 

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
      gnome3.enable = true;
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

  # Services
  services.redshift.enable = true;
  location.longitude = 1.8904;
  location.latitude = 51.4862;

  services.gvfs.enable = true;
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

  services.xserver.displayManager.sessionCommands = ''
    # Fix QT config app
    export QT_QPA_PLATFORMTHEME=qt5ct
  '';
}
