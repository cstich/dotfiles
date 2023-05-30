# Get the directory of the script
# https://stackoverflow.com/questions/242538/unix-shell-script-find-out-which-directory-the-script-file-resides
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# Make sure the path to the history file exists
mkdir -p ~/.symlinks/zsh_history/

ln -sf $SCRIPTPATH/nix/nixpkgs ~/.config/
ln -sf $SCRIPTPATH/config/zsh/zshrc ~/.zshrc
ln -sf $SCRIPTPATH/config/tmux/tmux.conf ~/.tmux.conf
ln -sf $SCRIPTPATH/config/helix ~/.config/
ln -sf $SCRIPTPATH/config/nvim ~/.config/
ln -sf $SCRIPTPATH/config/kitty ~/.config/
ln -sf $SCRIPTPATH/direnvrc ~/.direnvrc
ln -sf /home/$USER/Secrets/secrets.nix $SCRIPTPATH/nix/common/secrets.nix

# Import the key for pass
gpg --import .symlinks/secretes/pass.asc
pass init C09DE06BAC95A4D9

# Setup the rclone.conf for otter
mkdir -p ~/.config/rclone/
ln -sf /home/$USER/Secrets/rclone.conf ~/.config/rclone/rclone.conf

# TODO Think about how to deal with the hostname
sudo ln -sf $SCRIPTPATH/nix/$HOSTNAME.nix /etc/nixos/configuration.nix

# If gnome exists, set the custom settings
DESKTOP=$(env | grep XDG_CURRENT_DESKTOP | awk -F'=' '{print $2}')
if [[ $DESKTOP == "GNOME" ]]
then
    $SCRIPTPATH/config/gnome/gsettings.sh
fi

# This is the tmp dir for vim
mkdir -p ~/.tmp
# nvim -c "PlugInstall" -c "q" -c "q"
# nvim -c "PlugUpdate" -c "q" -c "q"

# Source nix-direnv hook
source ~/.direnvrc
