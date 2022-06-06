{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update nixos-unstable
  unstable = import <nixos-unstable> {};
in 

{
  environment.systemPackages = with pkgs; [
      bottom
      curl
      exa
      fzf
      git
      gptfdisk
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
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  }; 
    
  # Periodic trim of SSD partitions
  services.fstrim.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  nix.autoOptimiseStore = true; 
}
