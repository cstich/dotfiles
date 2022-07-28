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
      zip
    ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

  # Auto upgrades of packages from time to time
  system.autoUpgrade.enable = true;
  
  # Automated weekly garbage collection
  nix = {
    gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 14d";
    }; 

    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Periodic trim of SSD partitions
  services.fstrim.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Somehow logrotate fails
  services.logrotate.checkConfig = false;

  nix.autoOptimiseStore = true; 
}
