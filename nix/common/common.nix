{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
      ag
      busybox
      fzf
      git
      htop
      lshw
      neovim
      wget
      which
      zip
    ];

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
