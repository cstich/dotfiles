# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix

      ./common/common.nix
      ./common/neovim.nix
      ./common/fonts.nix
      ./common/gnome.nix
      ./common/shell.nix
    ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; 

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "magpie"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.gnome.gnome-remote-desktop.enable = true;
 
  # Hyper-V
  boot.kernelModules = [ "hv_sock" ];
  virtualisation.hypervGuest = {
    enable = true;
    videoMode = "1920x1080";
  };

  services.xserver = {
    modules = [ pkgs.xorg.xf86videofbdev ];
    videoDrivers = [ "hyperv_fb" ];
    autorun = true;
  };

  services.xrdp = {
          enable = true;
          defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";
          # defaultWindowManager = "${config.services.xserver.displayManager.session.wrapper}";
          package = pkgs.xrdp.overrideAttrs (old: rec {
            configureFlags = old.configureFlags ++ [ " --enable-vsock" ];
            postInstall = old.postInstall + ''
              ${pkgs.gnused}/bin/sed -i -e 's!use_vsock=false!use_vsock=true!g'                               $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!security_layer=negotiate!security_layer=rdp!g'                  $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!crypt_level=high!crypt_level=none!g'                            $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!bitmap_compression=true!bitmap_compression=false!g'             $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!FuseMountName=thinclient_drives!FuseMountName=shared-drives!g'  $out/etc/xrdp/sesman.ini
            '';
          });
        };

  environment.etc."X11/Xwrapper.config" = {
          mode = "0644";
          text = ''
            allowed_users=anybody
            needs_root_rights=yes
          '';
        };


  security.pam.services.xrdp-sesman-rdp = {
    text = ''
    auth      include   system-remote-login
    account   include   system-remote-login
    password  include   system-remote-login
    session   include   system-remote-login
  '';
  };

  security.polkit = {
    enable = true;
    extraConfig = ''
          polkit.addRule(function(action, subject) {
          if ((action.id == "org.freedesktop.color-manager.create-device" ||
               action.id == "org.freedesktop.color-manager.modify-profile" ||
               action.id == "org.freedesktop.color-manager.delete-device" ||
               action.id == "org.freedesktop.color-manager.create-profile" ||
               action.id == "org.freedesktop.color-manager.modify-profile" ||
               action.id == "org.freedesktop.color-manager.delete-profile") &&
               subject.isInGroup("users")) {
          return polkit.Result.YES;
      }
      });
    '';
  };

  environment.etc."X11/XLaunchXRDP" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      exec "${pkgs.gnome.gnome-session}/bin/gnome-session";
    '';
  };
 
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christoph = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keyFiles = [ "/home/christoph/Secrets/authorized_keys" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim 
    wget
    nix-index
    firefox
  ];

  environment.unixODBCDrivers = with pkgs.unixODBCDrivers; [ 
    msodbcsql17
    sqlite 
    psql 
  ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    ports = [8822];
  };

  # services.sshguard = {
  #   enable = true;
  #   detection_time = 604800;
  #   attack_threshold = 10;
  #   blocktime = 86400;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
