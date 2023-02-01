{config, pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins= ["git" "pass" "ssh-agent"];
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
  };

  programs.bash.enableCompletion = true;

  environment.systemPackages = [
    pkgs.powerline-go
    pkgs.direnv
    pkgs.fzf
  ];
}
