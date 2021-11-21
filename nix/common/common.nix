{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
  # sudo nix-channel --update nixpkgs-unstable
  unstable = import <nixpkgs-unstable> {};
in 

{
  environment.systemPackages = with pkgs; [
      ag
      bpytop
      curl
      busybox
      exa
      fzf
      git
      gptfdisk
      htop
      lshw
      lynis
      neovim
      p7zip
      procmail
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
    automatic = false;
    dates = "weekly";
    options = "--delete-older-than 90d";
  }; 

  nix.autoOptimiseStore = true; 
}
