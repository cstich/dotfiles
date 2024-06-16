#!/usr/bin/env bash
# Get the directory of the script
# https://stackoverflow.com/questions/242538/unix-shell-script-find-out-which-directory-the-script-file-resides
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

ln -sf $SCRIPTPATH/nix/nixpkgs ~/.config/
ln -sf $SCRIPTPATH/config/zsh/zshrc ~/.zshrc
rm ~/.config/fish -rf
ln -sf $SCRIPTPATH/config/fish ~/.config/
ln -sf $SCRIPTPATH/config/tmux/tmux.conf ~/.tmux.conf
ln -sf $SCRIPTPATH/config/helix ~/.config/
ln -sf $SCRIPTPATH/config/nvim ~/.config/
ln -sf $SCRIPTPATH/config/kitty ~/.config/
ln -sf $SCRIPTPATH/config/euporie ~/.config/
ln -sf $SCRIPTPATH/direnvrc ~/.direnvrc
ln -sf /home/$USER/Secrets/secrets.nix $SCRIPTPATH/nix/common/secrets.nix

# Import the key for pass
if command -v pass &> /dev/null
then
    gpg --import .symlinks/secrets/pass.asc
    pass init C09DE06BAC95A4D9
    # Remove any GPG config that sits in the home directory
    rm ~/.gnupg/gpg-agent.conf
fi

# Setup the rclone.conf for otter
if command -v rclone &> /dev/null
then
    mkdir -p ~/.config/rclone/
    ln -sf /home/$USER/Secrets/rclone.conf ~/.config/rclone/rclone.conf
fi

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
