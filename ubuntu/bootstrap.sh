## Empty the local bin directory
rm ~/.local/bin -rf
rm ~/.local/aws-cli -rf
mkdir ~/.local/bin

sudo apt update
sudo apt install distrobox powerline-go bat fd-find eza zoxide fish sudo gnome-browser-connector zoxide
snap install --classic helix



# Install kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    launch=n

# Download the latest version of helix
#rm helix* -rf
#wget https://github.com/helix-editor/helix/releases/download/24.03/helix-24.03-x86_64-linux.tar.xz -O helix.tar.xz
#tar -xf helix.tar.xz
#mv helix-24.03-x86_64-linux/* ~/.local/bin && rm helix* -rf
 
# Install nerd-fonts
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
~/nerd-fonts/install.sh FiraCode Iosevka IosevkaTerm

# Copy the config manually for now
rm -rf ~/.tmux.conf
rm -rf ~/.config/helix
rm -rf ~/.config/kitty
rm -rf ~/.config/nvim
rm -rf ~/.config/fish
rm -rf ~/.config/niri

# TODO Add euporie config
ln -sf ~/dotfiles/config/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/config/helix ~/.config/
ln -sf ~/dotfiles/config/niri ~/.config/
ln -sf ~/dotfiles/config/nvim ~/.config/
ln -sf ~/dotfiles/config/kitty ~/.config/
ln -sf ~/dotfiles/config/fish ~/.config/
ln -sf ~/dotfiles/config/direnv/direnvrc ~/.direnvrc
ln -sf ~/dotfiles/config/bat ~/.config
ln -sf ~/dotfiles/config/distrobox ~/.config

