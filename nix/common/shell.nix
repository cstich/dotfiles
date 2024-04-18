{config, pkgs, ...}:

let
    ssh-ident = pkgs.ssh-ident.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
            owner = "ccontavalli";
            repo = "ssh-ident";
            rev = "66a00104057411d85592411455261284d08bb065";
            sha256= "sha256-ThUEhwfw4B5BBEYU8UJspgMKgN8kgFVGHD43AO1el5g=";
        };   
    });
in


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
  ];

  environment.shells = with pkgs; [ fish ];
}
