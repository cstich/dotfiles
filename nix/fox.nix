{ config, pkgs, lib, ... }:

let
  ipEth = "192.168.1.1";
  extEth = "eno1";
  intEth = "enp2s0";
  wifi = "wlp1s0";
  secrets = import ./common/secrets.nix;
in

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # <nixpkgs/nixos/modules/profiles/hardened.nix>
      ./common/shell.nix
      ./common/common.nix
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

  networking.firewall = {
    enable = true;
    allowPing = true;
    trustedInterfaces = [ intEth ];
    checkReversePath = false; # https://github.com/NixOS/nixpkgs/issues/10101
    allowedTCPPorts = [
      8822    # ssh
      # 80    # http
      # 443   # https
      # 2222  # git
    ];
    allowedUDPPorts = [
    ];
  };

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
 
  # Setup dnsmasq as a DHCP server
  # You can set static IP addresses based on either host namaes or
  # mac addresses here
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
      dhcp-host=${secrets.macAddressOtter},192.168.1.240

      local=/lan/
      domain=lan
      expand-hosts

      cache-size=1000
      no-negcache
    '';
  };

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

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christoph = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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
    ports = [ 8822 ];
  };

  # TODO Set google auth up properly
  # security.pam.services.sudo.googleAuthenticator.enable = true;

  services.sshguard = {
    enable = true;
    detection_time = 604800;
    attack_threshold = 10;
    blocktime = 86400;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
    
  # Do not change this value
  system.stateVersion = "20.09"; 
}
