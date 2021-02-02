{ config, pkgs, lib, ... }:

let
  ipEth = "192.168.1.1";
  ipWifi = "192.168.2.1";
  extEth = "eno1";
  intEth = "enp2s0";
  wifi = "wlp1s0";
in

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./common/zsh.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable package forwarding.
    boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.ip_forward" = true;
    "net.ipv4.conf.${wifi}.forwarding" = true;
    "net.ipv6.conf.${wifi}.forwarding" = true;
   };

  networking.nameservers = ["10.77.0.1" "10.77.1.1" "127.0.0.1" "8.8.8.8" ]; # The first two are the PilsenFree DNS
  networking.domain = "lan";
  networking.hostName = "fox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.firewall = {
    enable = true;
    allowPing = true;
    trustedInterfaces = [ intEth ];
    checkReversePath = false; # https://github.com/NixOS/nixpkgs/issues/10101
    allowedTCPPorts = [
      22    # ssh
      # 80    # http
      # 443   # https
      # 2222  # git
    ];
    allowedUDPPorts = [];
  };

  services.haveged.enable = config.services.hostapd.enable;

  networking.hosts = {
    "192.168.1.1" = [ "ssh.fox.lan ssh.fox" ];
  };

  networking.nat = {
    enable = true;
    internalIPs = [ "192.168.1.0/24" ];
    externalInterface = extEth;
  };

  networking.interfaces = {
    enp2s0 = {
      ipv4.addresses = [{
        address = ipEth;
	prefixLength = 24;
      }];
    };
  }; 
  
  services.dnsmasq = {
    servers = ["8.8.8.8" "8.8.8.4" "10.77.0.1" "10.77.1.1"];
    enable = true;
    extraConfig = ''
      domain-needed
      bogus-priv
      listen-address=::1, 127.0.0.1, ${ipEth}

      interface=${intEth}
      bind-interfaces
      dhcp-range=192.168.1.10,192.168.1.254,24h

      local=/lan/
      domain=lan
      expand-hosts

      cache-size=1000
      no-negcache
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

   # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christoph = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [ "/home/christoph/Secrets/authorized_keys" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    google-authenticator
  ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    challengeResponseAuthentication = true;
    extraConfig = "# AuthenticationMethods publickey keyboard-interactive:pam";
  };

  security.pam.services.login.googleAuthenticator.enable = true;
  security.pam.services.sudo.googleAuthenticator.enable = true;
  # Add custom texts to the PAM sshd config files
  security.pam.services.sshd.text = pkgs.lib.mkDefault( pkgs.lib.mkBefore 
    "auth      required  pam_google_authenticator.so" );

  services.sshguard = {
    enable = true;
    detection_time = 3600;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "20.09"; 

}

