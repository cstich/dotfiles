{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
      ag
      fzf
      git
      htop
      neovim
      wget
      which
      zip
    ];
}
