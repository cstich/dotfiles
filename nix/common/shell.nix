{config, pkgs, ...}:

{
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.bash.completion.enable = true;

  environment.systemPackages = [
    pkgs.direnv
    pkgs.fzf
    pkgs.grc
    pkgs.fishPlugins.fzf-fish
    pkgs.powerline-go
    pkgs.zoxide
  ];

  programs.fish.interactiveShellInit = builtins.readFile "/home/christoph/dotfiles/config/fish/config.fish";

  environment.shells = with pkgs; [ fish ];
}
