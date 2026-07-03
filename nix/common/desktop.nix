{config, lib, pkgs, ...}:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in

{

  imports = [
  ];

  config = {
 
    environment.systemPackages = with pkgs; [

       # Themes
       arc-theme
       arc-icon-theme
       materia-theme
       lxappearance
       pantheon.elementary-icon-theme
       
       # Deskotp things
       alacritty
       dconf
       dconf-editor
       discord
       firefox
       foot
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
       peek
       qtpass
       seahorse
       transmission_4-gtk
       virtualbox
       veracrypt
       vscode-fhs
       vlc
       unstable.wezterm
       unstable.displaycal

       # Eclipse clipboard only works with thunar
       thunar
 
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

    # Enable Dank Linux
    programs.dms-shell = {
      enable = true;
      systemd.enable = true;
    };
    programs.niri.enable = true;
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };


    # Docker
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "christoph" ];
 
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
