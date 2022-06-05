{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update nixos-unstable
  unstable = import <nixos-unstable> {};
in 

{
  environment.systemPackages = with pkgs; [
      ag
      bottom
      curl
      busybox
      exa
      fzf
      git
      gptfdisk
      htop
      lshw
      lynis
      nix-index
      nmap
      p7zip
      procmail
      sshfs
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

  programs.neovim = {
    enable = true;
    package = unstable.neovim;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
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
  
  nix.autoOptimiseStore = true; 
}
