{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update nixos-unstable
  unstable = import <nixos-unstable> {};
in 

{
  environment.systemPackages = with pkgs; [
      bat
      bottom
      curl
      exa
      fzf
      git
      gptfdisk
      unstable.helix
      htop
      lshw
      lynis
      neofetch
      nix-index
      nmap
      patchelf
      p7zip
      procmail
      sshfs
      silver-searcher
      tmux
      wget
      which
      zellij
      zip
    ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

  # Add the minimal required C library for most binaries
  system.activationScripts.ldso = pkgs.lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  # Auto upgrades of packages from time to time
  system.autoUpgrade.enable = true;
  
  # Automated weekly garbage collection
  nix = {
    gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 14d";
   }; 
  };

  # Periodic trim of SSD partitions
  services.fstrim.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Somehow logrotate fails
  services.logrotate.checkConfig = false;

  nix.settings.auto-optimise-store = true; 
}
