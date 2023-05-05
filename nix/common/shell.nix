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
    pkgs.fishPlugins.grc
    pkgs.powerline-go
  ];

  environment.shells = with pkgs; [ fish ];
}
