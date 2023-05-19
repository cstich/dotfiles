{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update nixos-unstable
  unstable = import <nixos-unstable> {};
  neovim-python-packages = pythonPackages: with pythonPackages; [
    # neovim dependencies
    pynvim
    msgpack

    # magma dependencies
    jupyter-client
    ueberzug
    pillow
    cairosvg
    plotly

    # dev dependencies
    cookiecutter
    flake8
    isort
    pylint
    yapf
  ]; 
  neovim-python = pkgs.python3.withPackages neovim-python-packages;

  neovim-custom = pkgs.neovim.override {
    withPython3 = true;
    extraPython3Packages = neovim-python-packages;
  };

in 

{
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";
  environment.systemPackages = with pkgs; [
    neovim-python 

    fzf
    yarn
    ctags
  
    # Rust nvim client
    neovide

    # Telescope
    fd
    ripgrep

    # Tree sitter depenencies
    # Don't use clang as it doesn't work on NixOS
    gcc
    tree-sitter
    git
    curl

    # Python language server
    nodePackages.pyright

    # Eclipse language server
    jdt-language-server 

    # Dependency for copying to the system clipboard
    xclip
    neovim-custom
  ];
}
