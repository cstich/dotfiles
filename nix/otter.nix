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
      # ./wifi-ap.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-ST500LM021-1KJ152_W6248MN7";
  boot.zfs.requestEncryptionCredentials = true;
  boot.supportedFilesystems = [ "zfs" ]; 

  # Use 
  # sudo zpool create -o ashift=12 -o altroot="/mnt" -O mountpoint=none -O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt zbackup mirror /dev/disk/by-id/ata-TOSHIBA_HDWA120_Y61R1PXAS /dev/disk/by-id/ata-TOSHIBA_HDWA120_Y61R1RRAS -f
  # sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true zbackup/backup
  # sudo mount -t zfs zbackup/backup /mnt/backup
  # Don't forget to ensure /mnt/backup exists
  # to create the zfs encrypted mirrored pool 

  networking.hostName = "otter"; # Define your hostname.
  networking.hostId = "9e0f15c5"; # We use head -c 8 /etc/machine-id to get a unique id for each machine for zfs

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp6s0 = {
    useDHCP = true;
  };
  networking.interfaces.wlp2s0.useDHCP = false;

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8;
    monthly = 3;
  };

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

  users.users.lenka = {
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.bash;
    openssh.authorizedKeys.keyFiles = [ "/home/lenka/.ssh/id_rsa.pub"];
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
    settings.passwordAuthentication = false;
    settings.permitRootLogin = "no";
    extraConfig = "# AuthenticationMethods publickey keyboard-interactive:pam";
  }; 

   # To connect to this at boot use 'ssh -i ~/Secrets/ssh_otter_boot_host_ed25519_key root@192.168.1.240 -p 2222'
   boot = {
    # Make sure you have added the kernel module for your network driver to `boot.initrd.availableKernelModules`; use 'lshw -C network' to find out which driver is needed for the ethernet interface at boot
    initrd.availableKernelModules = [ "r8169" ];
    initrd.network = {
      # This will use udhcp to get an ip address.
      # so your initrd can load it!
      # Static ip addresses might be configured using the ip argument in kernel command line:
      # https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
      enable = true;
      ssh = {
         enable = true;
         # To prevent ssh from freaking out because a different host key is used,
         # a different port for dropbear is useful (assuming the same host has also a normal sshd running)
         port = 2222; 
     # Use 'ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/ssh_host_ed25519_key' to generate the host keys
     # Unless your bootloader supports initrd secrets, these keys are stored insecurely in the global Nix store. Do NOT use your regular SSH host private keys for this purpose or you'll expose them to regular users!
     # Additionally, even if your initrd supports secrets, if you're using initrd SSH to unlock an encrypted disk then using your regular host keys exposes the private keys on your unencrypted boot partition.
         hostKeys = [ "/etc/ssh/initrd/ssh_host_ed25519_key" ];
         # public ssh key used for login
     
         authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgvhQ+m97RK8X2Q308mQsu9yl+w9Bcg3mSzVpALlu4C root@otter"];
      };
      # this will automatically load the zfs password prompt on login
      # and kill the other prompt so boot can continue
      postCommands = ''
        zpool import zbackup
        echo "zfs load-key -a; killall zfs" >> /root/.profile
      '';
    };
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
