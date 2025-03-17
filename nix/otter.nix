# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # <nixpkgs/nixos/modules/profiles/hardened.nix>
      ./common/common.nix
      ./common/shell.nix
      ./common/fonts.nix
      ./common/syncthing.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ]; 

  # Instructions for a zfs encrypted raid
  # Don't forget to ensure /mnt/backup exists
  # to create the zfs encrypted mirrored pool 
  # 
  # sudo zpool create -o ashift=12 -o altroot="/mnt" -O mountpoint=none -O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt zbackup mirror /dev/disk/by-id/ata-ST2000DM008-2FR102_ZFL5WKXG /dev/disk/by-id/ata-ST2000DM008-2UB102_ZK30K40Q -f
  # sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true zbackup/backup
  # sudo mount -t zfs zbackup/backup /mnt/backup

  # Mount zfs pool
  fileSystems."/mnt/backup" = {
    device = "zbackup";
    fsType = "zfs";
  };
  services.zfs.autoScrub.enable = true;

  networking.hostName = "otter"; # Define your hostname.
  networking.hostId = "9e0f15c5"; # We use head -c 8 /etc/machine-id to get a unique id for each machine for zfs

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp6s0 = {
    useDHCP = true;
  };

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8;
    monthly = 3;
  };
  
  
  # Set your time zone.
  time.timeZone = "Europe/London";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Create a new group for the backup folder
  users.groups.backupadmins= {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christoph = {
    isNormalUser = true;
    extraGroups = [ "wheel" "backupadmins" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keyFiles = [ "/home/christoph/Secrets/authorized_keys" ];
  };

  users.users.backupuser= {
    isNormalUser = true;
    extraGroups = [ "wheel" "backupadmins"];
  };

  services.sshguard = {
    enable = true;
    detection_time = 86400;
    attack_threshold = 50;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    rclone
    google-authenticator
  ]; 

  # TODO Set google auth up properly
  # security.pam.services.login.googleAuthenticator.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
    extraConfig = "# AuthenticationMethods publickey keyboard-interactive:pam";
  }; 

 services.borgbackup.jobs.home-otter = {
    paths = ["/home/christoph/archive" "/home/christoph/.symlinks"];
    repo = "/mnt/backup/christoph/";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /home/christoph/Secrets/borgbackup_passphrase";
    };
    compression = "auto,lzma";
    startAt = "daily";
  };

   systemd.services.backblaze-backup = {
      serviceConfig.Type = "oneshot";
      script = ''
        echo "Starting backblaze backup."
        ${pkgs.rclone}/bin/rclone sync --config "/home/christoph/Secrets/rclone.conf" -v /mnt/backup encrypted_b2:/backup/
        echo "Finished backblaze backup."
      '';
    };

    systemd.timers.backblaze-backup = {
      wantedBy = [ "timers.target" ];
      partOf = [ "backblaze-backup.service" ];
      timerConfig.OnCalendar = [ "*-*-* 4:00:00"];
    };

  system.stateVersion = "20.09"; # Can be left at first installed version
}
