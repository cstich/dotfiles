## Empty the local bin directory
rm ~/.local/bin -rf
rm ~/.local/aws-cli -rf
mkdir ~/.local/bin

# Install distrobox
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local

# Install terraform
curl "https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_amd64.zip" -o "terraform.zip"
unzip terraform.zip 
mv terraform ~/.local/bin 
rm terraform.zip

# Install AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install -i ~/.local/aws-cli -b ~/.local/bin --update
rm awscliv2.zip aws -rf

# Download powerline-go
wget https://github.com/justjanne/powerline-go/releases/download/v1.24/powerline-go-linux-amd64
chmod +x powerline-go-linux-amd64 
mv powerline-go-linux-amd64 ~/.local/bin/powerline-go 
rm powerline-* -rf

# Download bat
wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz -O bat.tar.gz
tar -xf bat.tar.gz
mv bat-*/bat ~/.local/bin/bat && rm bat* -rf

# Download fd
wget https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz -O fd.tar.gz
tar -xf fd.tar.gz
rsync -av fd-*/* ~/.local/bin && rm fd* -rf

# Download eza
wget https://github.com/eza-community/eza/releases/download/v0.18.0/eza_x86_64-unknown-linux-gnu.tar.gz -O eza.tar.gz
tar -xf eza.tar.gz
mv eza ~/.local/bin/eza && rm eza* -rf

# Download the latest version of helix
rm helix* -rf
wget https://github.com/helix-editor/helix/releases/download/24.03/helix-24.03-x86_64-linux.tar.xz -O helix.tar.xz
tar -xf helix.tar.xz
mv helix-24.03-x86_64-linux/* ~/.local/bin && rm helix* -rf
 
# Download hatch
wget https://github.com/pypa/hatch/releases/download/hatch-v1.9.3/hatch-1.9.3-x86_64-unknown-linux-gnu.tar.gz -O hatch.tar.gz
tar -xf hatch.tar.gz
mv hatch-1.* ~/.local/bin/hatch && rm hatch* -rf 

# Install nerd-fonts
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
~/nerd-fonts/install.sh FiraCode Iosevka IosevkaTerm

# Install quarto
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.450/quarto-1.3.450-linux-amd64.tar.gz -O quarto.tar.gz
tar -xf quarto.tar.gz
mv quarto-1.3.450 ~/.local/quarto
ln -s ~/.local/quarto/bin/quarto ~/.local/bin/quarto
rm quarto-*

# Install zoxide
wget https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.3/zoxide-0.9.3-x86_64-unknown-linux-musl.tar.gz -O z.tar.gz
tar -xf z.tar.gz
mv zoxide ~/.local/bin/zoxide
rm z.tar.gz

# TODO Copy libnss_sss. This seems to be missing for nix-portable
# Can be found here: /usr/lib/x86_64-linux-gnu/libnss_sss.so.2

# Install python system dependencies
wget https://github.com/pypa/pipx/releases/download/1.5.0/pipx.pyz
mv pipx.pyz ~/.local/bin/
python3 ~/.local/bin/pipx.pyz ensurepath
pipx='python3 /home/christoph.stich/.local/bin/pipx.pyz'

$pipx install cruft --force
$pipx install ruff --force
$pipx install "python-lsp-server[rope]" --force
$pipx install pyright --force
$pipx install docformatter --force
$pipx install uv==0.1.39 --force
$pipx install cmake-language-server --force

# Install uv
# curl -LsSf https://astral.sh/uv/install.sh | sh
# source /home/christoph.stich/.cargo/env

# Install typos
wget https://github.com/tekumara/typos-lsp/releases/download/v0.1.12/typos-lsp-v0.1.12-x86_64-unknown-linux-gnu.tar.gz -O typos-lsp.tar.gz
tar -xf typos-lsp.tar.gz
mv typos-lsp ~/.local/bin/ && rm typos-lsp -rf

# Enable scrolling for Wacom Tablet
# use `xsetwacom --list devices` to find devices
xsetwacom --set "Wacom One by Wacom M Pen stylus" Button 2 "pan"
xsetwacom --set "Wacom One by Wacom M Pen stylus" "PanScrollThreshold" 200

# Copy the config manually for now
rm -rf ~/.tmux.conf
rm -rf ~/.config/helix
rm -rf ~/.config/kitty
rm -rf ~/.config/nvim
rm -rf ~/.config/fish

# TODO Add euporie config
ln -sf ~/dotfiles/config/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/config/helix ~/.config/
ln -sf ~/dotfiles/config/nvim ~/.config/
ln -sf ~/dotfiles/config/kitty ~/.config/
ln -sf ~/dotfiles/config/fish ~/.config/
ln -sf ~/dotfiles/config/direnv/direnvrc ~/.direnvrc
ln -sf ~/dotfiles/config/bat ~/.config
ln -sf ~/dotfiles/config/distrobox ~/.config

