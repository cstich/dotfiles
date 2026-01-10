{config, lib, pkgs, ...}:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in

{

  imports = [
  ];

  config = {
 
    environment.systemPackages = with pkgs; [

       # Gnome things
       gnome-tweaks
       dconf-editor
       gedit
       gnome-session
       gnome-terminal
       networkmanager-openvpn
       seahorse

       gnomeExtensions.vertical-workspaces
       gnomeExtensions.paperwm
       gnomeExtensions.window-is-ready-remover
      
       arc-theme
       arc-icon-theme
       materia-theme
       lxappearance
       pantheon.elementary-icon-theme
       
       # Deskotp things
       alacritty
       dconf
       discord
       firefox
       google-chrome
       gparted
       git-filter-repo
       discord
       kupfer
       kitty
       lapce
       libreoffice
       meld
       unstable.onedrive
       bitwarden-cli
       bitwarden-desktop
       peek
       qtpass
       transmission_4-gtk
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
       libsForQt5.qt5ct
      
       # RDP client
       remmina

       # containers
       distrobox
      ];
      
    # Enable touchpad support.
    services.libinput.enable = true;

    # Enable gnome
    services = {
      desktopManager = {
        gnome.enable = true;
      };

      displayManager = {
        gdm.enable = true;
      }; 
    };

    # Docker
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "christoph" ];
 
    # Enable sound.
    services.pulseaudio.enable = false;
    # rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # Steam is a funny program to install
    # TODO This currently fails; open issue
    programs.steam.enable = true; 
    programs.ssh.enableAskPassword = false;

    # Allow flatpaks
    services.flatpak.enable = true;

    services.gvfs.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;
    services.udev.packages = with pkgs; [ gnome-settings-daemon ]; 
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
