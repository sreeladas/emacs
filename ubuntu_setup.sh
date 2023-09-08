#!/bin/sh

# Welcome to the on-boarding script!
# Ubuntu basic utility installs for Sreela
# Some recommended customizations based on past experience
sudo apt update
sudo apt upgrade

# This is to install gnome-clocks
sudo add-apt-repository universe
sudo apt install gnome-clocks

# This is the section with the main "dev-tools"
sudo apt install emacs
cp -r ./systemd/* ~/.config/systemd/user/
cp ./autostart/emacs.desktop ~/.config/autostart/

# Install python, poetry and jupyter
sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
cd ~/.pyenv && src/configure && make -C src

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
echo 'eval "$(pyenv init --path)"' >> ~/.zprofile

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init --path)"' >> ~/.profile

echo 'eval "$(pyenv init -)"' >> ~/.zshrc

source ~/.zshrc
pyenv install 3.8.12
pyenv install 3.9.9
pyenv global 3.9.9

pip install poetry
python3 -m pip install --upgrade pip
python3 -m pip install jupyter

# Install guake and zsh
sudo apt install guake
cp ./autostart/guake.desktop ~/.config/autostart/
sudo apt install zsh zsh-completions zsh-syntax-highlighting

# Install git and github cli
sudo apt install git
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh


# Install docker and docker-compose
sudo apt remove docker docker-compose docker-engine docker.io containerd runc
sudo apt update && sudo apt upgrade

sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

read -p "Is this the correct key? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
   sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) \
         stable"
   sudo apt install docker-ce docker-ce-cli containerd.io
   sudo docker run hello-world
   sudo groupadd docker
   sudo usermod -aG docker $USER
   newgrp docker
   sudo systemctl enable docker.service
   sudo systemctl enable containerd.service
   
fi

# Mods to zshrc
if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
else
    zshrc="$HOME/.zshrc"
fi

append_to_zshrc() {
  local text="$1" zshrc

  # Prevent redundancy in the zshrc file, only write to zshrc if not already there
  if ! grep -Fqs "$text" "$zshrc"; then
      printf "\\n%s\\n" "$text" >> "$zshrc"
  fi
}

# Optional mods for iterm2
pushd $HOME/Documents/

# Gets some fun features that shows you current git branch etc. Need to activate by adding this into ~/.zshrc
gh repo clone romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
for repo_name in "sreeladas" "sreeladas.github.io" "emacs" "CV"; do
    gh repo clone sreeladas/$repo_name;
done;

popd

append_to_zshrc '
bind \'"\e[A":history-search-backward\'
bind \'"\e[B":history-search-forward\'
'
append_to_zshrc '# Sets plugins for oh-my-zsh with auto-complete for docker and git info in the
plugins=(git docker docker-compose)'
append_to_zshrc '# Sets a theme for iterm2 that detects and displays the git branch and status of working directory
ZSH_THEME="powerlevel10k/powerlevel10k"'

append_to_zshrc '# Once powerlevel10k is installed and activated, this activates the version control features
POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir virtualenv vcs)'

append_to_zshrc '# This shows the status, background jobs and history time
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)'

append_to_zshrc "# General alias section
# Useful aliases for docker
alias poadd='poetry add'
alias poins='poetry install'
alias posh='poetry shell'
alias pore='poetry remove'
alias ins='sudo apt install'
alias upgrage='sudo apt update && sudo apt upgrade'

# display path with each directory in a new line
alias path='echo -e \${PATH//:/\\\n}'
alias ~='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
"

# Add personal packages
# NOTE: These instructions only work for 64 bit Debian-based
# Linux distributions such as Ubuntu, Mint etc.

# 1. Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc |\
  sudo apt-key add -

# 2. Add our repository to your list of repositories
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" |\
  sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

# 3. Update your package database and install signal
sudo apt update && sudo apt install signal-desktop


# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add fusuma for gesture inputs
sudo gpasswd -a $USER input
newgrp input
sudo apt install libinput-tools
sudo apt install ruby
sudo gem install fusuma
sudo apt install xdotool
cp ./autostart/fusuma.desktop ~/.config/autostart/
