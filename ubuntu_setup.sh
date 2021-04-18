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
sudo apt install python3
sudo apt install python3-pip
sudo apt install poetry
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

append_to_zshrc '# Sets a theme for iterm2 that detects and displays the git branch and status of working directory
ZSH_THEME="powerlevel10k/powerlevel10k"'

append_to_zshrc '# Once powerlevel10k is installed and activated, this activates the version control features
POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir virtualenv vcs)'

append_to_zshrc '# This shows the status, background jobs and history time
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)'

append_to_zshrc '# This puts the cursor on a new which is useful if you have long directory names or long git repo names
POWERLEVEL10K_PROMPT_ON_NEWLINE=true'

append_to_zshrc "# General alias section 
# Useful aliases for docker
alias pipins='poetry add'
alias pipun='poetry remove'
alias ins='sudo apt install'
alias upgrage='sudo apt update && sudo apt upgrade'
alias dbuild='docker build -t api:latest .'
alias drun='docker run -p 8080:8080 api:latest'
alias drun_with_volumes='docker run -p 8080:8080 -v $PWD api:latest'
alias dps='docker ps'
alias dexec='function docker_exec(){docker exec -it $1 /bin/bash}; docker_exec'
# display path with each directory in a new line
alias path='echo -e \${PATH//:/\\\n}'
alias ~='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'

# git aliases
alias git_pr_branch='function pr_branch(){git fetch; git checkout $1; git pull origin $1}; pr_branch'"

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


# Add fusuma for gesture inputs
sudo gpasswd -a $USER input
newgrp input
sudo apt install libinput-tools
sudo apt install ruby
sudo gem install fusuma
sudo apt install xdotool
cp ./autostart/fusuma.desktop ~/.config/autostart/
