# Change to the right directory

# Get the directory of the script
# https://stackoverflow.com/questions/242538/unix-shell-script-find-out-which-directory-the-script-file-resides
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

ln -sf $SCRIPTPATH/config/nixpkgs ~/.config
ln -sf $SCRIPTPATH/config/zsh/zshrc ~/.zshrc
ln -sf $SCRIPTPATH/config/nvim ~/.config
sudo ln -sf $SCRIPTPATH/nix/configuration.nix /etc/nixos/configuration.nix

mkdir -p ~/.tmp
