# Why this repo ? 

My dotfiles are... useful for when setting up a new ubuntu pc.

## What should you install ?

The dotfiles in this repo are simple config files to your tastes. When setting
up a new ubuntu pc, you should at the very least install the following:

- [ ] Chrome
- [ ] emacs and doom emacs !!!
- [ ]  kitty
- [ ] zsh and oh-my-zsh
- [ ] nvim
- [ ] R
- [ ] radian
- [ ] yazi and ya
- [ ] git
- [ ] Lazygit
- [ ] figlet and toilet

## Installation Commands (Ubuntu)

### Update system

```bash
# Update package list
sudo apt update && sudo apt upgrade -y
```

### Install git

```bash
sudo apt install -y git
```

### Install Chrome

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f -y
rm google-chrome-stable_current_amd64.deb
```

### Install kitty

```bash
sudo apt install -y kitty
```

### Install zsh

```bash
sudo apt install -y zsh
```

### Install oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install nvim

```bash
# Latest stable via PPA
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt update
sudo apt install -y neovim
```

### Install R

```bash
# Latest version via CRAN
sudo apt install -y software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marwich.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt update
sudo apt install -y r-base r-base-dev
```

### Install radian

```bash
# Install Python and pip first
sudo apt install -y python3 python3-pip

# Install radian
pip3 install radian
```

### Install yazi and ya

```bash
# Install Rust toolchain (if not already installed)
cargo --version || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Install yazi
cargo install --locked yazi-fm yazi-cli
```

### Install Lazygit

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
```
### Install figlet and toilet

```bash
sudo apt install figlet
sudo apt install toilet

sudo curl "https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf" \
  -o /usr/share/figlet/ANSI_Shadow.flf
```
## Post-Installation Configuration

### Set kitty as default terminal (Ctrl+Alt+T)

```bash
# Option 1: Update default terminal via update-alternatives
sudo update-alternatives --config x-terminal-emulator
# Then select kitty from the list
```

Or manually set via GNOME settings:

1. Open Settings → Keyboard → Keyboard Shortcuts
2. Find "Launch terminal" or search for the Ctrl+Alt+T binding
3. Click on it and change the command to `kitty`

Or via command line (GNOME):

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Kitty Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'kitty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Primary><Alt>t'
```

### Set zsh as default shell

```bash
chsh -s $(which zsh)
```

### Add ~/.local/bin to PATH (for radian)

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

**Note:** Restart your terminal after installing oh-my-zsh and setting
zsh as default.
