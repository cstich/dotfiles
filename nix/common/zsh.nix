{config, pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins= ["git" "pass" "ssh-agent"];
    syntaxHighlighting.enable = true;
  };

  environment.systemPackages = [
    pkgs.powerline-go
  ];
}
