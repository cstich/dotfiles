{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update nixos-unstable

  unstable = import <nixos-unstable> {};
  myPythonPackages = pythonPackages: with pythonPackages; [
    cookiecutter
    flake8
    isort
    pylint
    yapf

    python-lsp-server
  ] ++ python-lsp-server.all ; 
in 

{
  environment.systemPackages = with pkgs; [
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
  ];
}
