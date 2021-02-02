# Change to the right directory

# Get the directory of the script
# https://stackoverflow.com/questions/242538/unix-shell-script-find-out-which-directory-the-script-file-resides
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

ln -sf $SCRIPTPATH/nix/nixpkgs ~/.config
ln -sf $SCRIPTPATH/config/zsh/zshrc ~/.zshrc
ln -sf $SCRIPTPATH/config/nvim ~/.config
ln -sf $SCRIPTPATH/direnvrc ~/.direnvrc
ln -sf /home/$USER/.symlinks/secrets/secretx.nix $SCRIPTPATH/nix/secrets.nix

# TODO Think about how to deal with the hostname
sudo ln -sf $SCRIPTPATH/nix/$HOSTNAME.nix /etc/nixos/configuration.nix

# If gnome exists, set the custom settings
DESKTOP=$(env | grep XDG_CURRENT_DESKTOP | awk -F'=' '{print $2}')
if [[ $DESKTOP -eq GNOME ]]
then
    config/gnome/gsettings.sh
fi

mkdir -p ~/.tmp
