#!/bin/sh

# Welcome to the on-boarding script!
# MacOS basic utility installs for labs and
# Some recommended customizations for those without stronger opinions
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew upgrade --all

brew install python3
brew cask install pycharm-ce

python3 -m pip install --upgrade pip
python3 -m pip install jupyter

brew cask install sequel-pro

brew cask install iterm2

brew install zsh zsh-completions zsh-syntax-highlighting

brew instal git

brew cask install postman

brew cask install docker


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

read -p "Would you like to download the suggested customizations for iterm2? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then    
    # Optional mods for iterm2
    pushd $HOME/Documents/
    
    # Gets color scheme. Need to activate in iterm2 preferences
    curl -O https://raw.githubusercontent.com/Clovis-team/clovis-open-code-extracts/master/utils/Clovis-iTerm2-Color-Scheme.itermcolors
    
    # Gets a font that can handle glyphs. Need to activate in iterm2 preferences
    curl -O https://github.com/powerline/fonts/blob/master/SourceCodePro/Source%20Code%20Pro%20for%20Powerline.otf
    
    # Gets some fun features that shows you current git branch etc. Need to activate by adding this into ~/.zshrc
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    popd

    append_to_zshrc '# Sets a theme for iterm2 that detects and displays the git branch and status of working directory
ZSH_THEME="powerlevel9k/powerlevel9k"'

    append_to_zshrc '# Once powerlevel9k is installed and activated, this activates the version control features
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)'

    append_to_zshrc '# This shows the status, background jobs and history time
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)'

    append_to_zshrc '# This puts the cursor on a new which is useful if you have long directory names or long git repo names
POWERLEVEL9K_PROMPT_ON_NEWLINE=true'
fi
echo "To implement these, you will need to open: 
iterm2 > Preferences > Profiles > Colors > Color Presets > Import 
       and find Clovis in the browser 
iterm2 > Preference > Profiles > Text > Change Font > find 
       the Source Code Pro font. 
Read more about this at https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961"

append_to_zshrc "# General alias section 
# Useful aliases for docker
alias dbuild='docker build -t api:latest .'
alias drun='docker run -p 8080:8000 api:latest'
alias drun_with_volumes='docker run -p 8080:8000 -v $PWD/labs-products api:latest'
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
alias git_pr_branch='function pr_branch(){git fetch $1 $2; git checkout $2}; pr_branch'"