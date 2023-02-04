{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update nixos-unstable

  unstable = import <nixos-unstable> {};
  myPythonPackages = pythonPackages: with pythonPackages; [
  ];
in 

{
  environment.systemPackages = with pkgs; [
    unstable.helix
  
    (python3.withPackages myPythonPackages)
    fzf
    yarn
    ctags
  
    # Telescope
    fd
    ripgrep

    # Tree sitter depenencies
    clang
    tree-sitter
    git
    curl

    # Python language server
    nodePackages.pyright

    # Eclipse language server
    jdt-language-server

    # System clipboard
    xclip

  ];
}
