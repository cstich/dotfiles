{config, pkgs, ...}:

{
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.bash.enableCompletion = true;

  environment.systemPackages = [
    pkgs.direnv
    pkgs.fzf
    pkgs.grc
    pkgs.fishPlugins.fzf-fish
    pkgs.powerline-go
    pkgs.zoxide
  ];

  environment.shells = with pkgs; [ fish ];
}
