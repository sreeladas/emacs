#!/bin/zsh

# Welcome to the on-boarding script!
# MacOS basic utility installs for labs and
# Some recommended customizations for those without stronger opinions

# Installs homebrew, a command line package manager for macOS (similar to those for linux, or e.g. pip for python)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Updates homebrew repositories
brew update
brew upgrade --all

# Installs python 3.x.x, at the moment, this is 3.9.1, this version of python should really only be used for e.g. pre-commit environments or for installing poetry.
RELPY=''
echo -n "Would you like to install python 3.x.x from Homebrew? (see https://formulae.brew.sh/formula/python@3.9#default ):  "
read REPLY
if [[ $REPLY =~ ^[1]$ ]]
then
    brew install python3
fi

# Installs your preferred IDE
# Pick your favourite of the following, or stick with vim or use spacemacs instead
RELPY=''
echo -n "Would you like to install one of the preferred IDE/text-editors?\n1 - PyCharm \n2 - PyCharm Community Edition (No License) \n3 - VSCode \n4 - Emacs\n\n0 - No thanks I'll setup my own IDE:  "
read REPLY
if [[ $REPLY =~ ^[1]$ ]]
then
    brew install --cask pycharm
elif [[ $REPLY =~ ^[2]$ ]]
then
    brew install --cask pycharm-ce
elif [[ $REPLY =~ ^[3]$ ]]
then
    brew install --cask visual-studio-code
elif [[ $REPLY =~ ^[4]$ ]]
then
    brew install --cask emacs
fi
echo "\n"


# Upgrades pip and installs jupyter to use jupyter notebooks
RELPY=''
echo -n "Would you like to install jupyter to locally run jupyter notebooks?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    python3 -m pip install --upgrade pip
    python3 -m pip install jupyter
    echo "\n"
fi

# Installs poetry, for environment management
RELPY=''
echo -n "Would you like to install poetry for local python environment management?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    pip3 install poetry
    echo "\n"
fi

RELPY=''
echo -n "Would you like to install sequel-pro to explore databases and for interactive query editing?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask sequel-pro
    echo "\n"
fi

RELPY=''
echo -n "Would you like to install iterm2 to replace the macOS terminal? (see https://iterm2.com/ for reference on features)?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask iterm2
    echo "\n"
fi

RELPY=''
echo -n "Would you like to install oh-my-zsh for command line helper functions (see https://ohmyz.sh/)?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install zsh zsh-completions zsh-syntax-highlighting
    echo "\n"
fi

RELPY=''
echo -n "Would you like to install git for version control?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew instal git
    echo "\n"
fi

RELPY=''
echo -n "Would you like to install postman for testing/accessing of APIs (see https://www.postman.com/ )?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask postman
    echo "\n"
fi

RELPY=''
echo -n "Would you like to install docker and docker compose for running containerized apps and development environments (see https://docs.docker.com/engine/ )?:  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask docker
    brew install docker-compose
    echo "\n"
fi


# Mods to zshrc
if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
else
    zshrc="$HOME/.zshrc"
    echo "\n"
fi

append_to_zshrc() {
  local text="$1" zshrc

  # Prevent redundancy in the zshrc file, only write to zshrc if not already there
  if ! grep -Fqs "$text" "$zshrc"; then
      printf "\\n%s\\n" "$text" >> "$zshrc"
  fi
}

RELPY=''
echo -n "Would you like to download+add the suggested (appearance) customizations for iterm2? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then    
    # Optional mods for iterm2
    pushd $HOME/Documents/
    
    # Gets color scheme. Need to activate in iterm2 preferences
    curl -O https://raw.githubusercontent.com/Clovis-team/clovis-open-code-extracts/master/utils/Clovis-iTerm2-Color-Scheme.itermcolors
    
    # Gets a font that can handle glyphs. Need to activate in iterm2 preferences
    curl -O https://github.com/powerline/fonts/blob/master/SourceCodePro/Source%20Code%20Pro%20for%20Powerline.otf
    
    # Gets some fun features that shows you current git branch etc. Need to activate by adding this into ~/.zshrc
    git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    popd

    append_to_zshrc '# Sets a theme for iterm2 that detects and displays the git branch and status of working directory
ZSH_THEME="powerlevel10k/powerlevel10k"'

    append_to_zshrc '# Once powerlevel10k is installed and activated, this activates the version control features
POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)'

    append_to_zshrc '# This shows the status, background jobs and history time
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)'

    append_to_zshrc '# This puts the cursor on a new which is useful if you have long directory names or long git repo names
POWERLEVEL10K_PROMPT_ON_NEWLINE=true'
    echo "To implement these, you will need to open: 
iterm2 > Preferences > Profiles > Colors > Color Presets > Import 
       and find Clovis in the browser 
iterm2 > Preference > Profiles > Text > Change Font > find 
       the Source Code Pro font. 
Read more about this at https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961"
    echo "\n"
fi

RELPY=''
echo -n "Would you like to some common aliases to your terminal? These are basically shortcuts for command line commands. (read more at https://www.geeksforgeeks.org/alias-command-in-linux-with-examples/ ) (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then    
append_to_zshrc "# General alias section 
_dbuild () {
        docker build -t ${PWD##*/}:latest
}
_drun () {
        docker run -name ${PWD##*/} -p 8080:8080 ${PWD##*/}:latest
}
_dexec () {
       docker exec -it ${PWD##*/} /bin/bash
}

# Useful aliases for docker
alias dbuild='_dbuild'
alias drun='_drun'
alias dps='docker container ls'
alias dexec='_dexec'

# display path with each directory in a new line
alias path='echo -e \${PATH//:/\\\n}'
alias ~='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'

# poetry aliases to install a package, enter a shell, remove a package
alias poadd='poetry add'
alias poins='poetry install'
alias posh='poetry shell'
alias pore='poetry remove'

pathmunge () {
        if ! echo '$PATH' | grep -Eq '(^|:)$1($|:)' ; then
           if [ '$2' = 'after' ] ; then
              PATH='$PATH:${1:A}'
           else
              PATH='${1:A}:$PATH'
              echo "\n"
fi
        echo "\n"
fi
}

# git aliases
alias git_pr_branch='function pr_branch(){git fetch; git checkout $1; git pull origin $1}; pr_branch'"
fi