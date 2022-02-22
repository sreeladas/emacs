#!/bin/zsh

# Welcome to the on-boarding script!
# MacOS basic utility installs for labs and
# Some recommended customizations for those without stronger opinions

# Installs homebrew if not found, a command line package manager for macOS (similar to those for linux, or e.g. pip for python)
command -v brew /dev/null 2>&1 || {
    echo >&2 "Homebrew not found, Installing now"; \
        /usr/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
}

# Updates homebrew repositories
brew update
brew upgrade

append_to_zshrc() {
  local text="$1" zshrc

  # Prevent redundancy in the zshrc file, only write to zshrc if not already there
  if ! grep -Fqs "$text" "$zshrc"; then
      printf "\\n%s\\n" "$text" >> "$zshrc"
  fi
}

# Installs pyenv. Pyenv will nicely handle python versions and allow you to not worry about system pythons
REPLY=''
echo -n "Would you like to install pyenv from Homebrew? This step will also install the currently recommended version of python (3.8.9) as the global default (see https://github.com/pyenv/pyenv ) (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install pyenv
    pyenv install 3.8.12
    pyenv install 3.9.9
    pyenv global 3.8.12
    append_to_zshrc 'if command -v pyenv 1>/dev/null/ 2>&1; then\n    eval "$(pyenv init -)"\nfi'
fi

# Installs your preferred IDE
# Pick your favourite of the following, or stick with vim or use spacemacs instead
REPLY=''
echo -n "Would you like to install one of the preferred IDE/text-editors?\n1 - PyCharm \n2 - PyCharm Community Edition (No License) \n3 - VSCode \n4 - Emacs\n\n0 - No thanks I'll setup my own IDE (0/1/2/3/4):  "
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


# Installs google cloud sdk. Cloud SDK give you a neat interface for interacting with google
REPLY=''
echo -n "Would you like to install google cloud sdk from Homebrew? (see https://cloud.google.com/sdk/docs/install ) (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask google-cloud-sdk
fi
echo "\n"

# Upgrades pip and installs jupyter to use jupyter notebooks
REPLY=''
echo -n "Would you like to install jupyter to locally run jupyter notebooks? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    pip install --upgrade pip
    pip install jupyter
    echo "\n"
fi

# Installs poetry, for environment management
REPLY=''
echo -n "Would you like to install poetry for local python environment management (see more https://python-poetry.org/ )? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
    echo "\n"
fi

REPLY=''
echo -n "Would you like to install sequel-ace to explore databases and for interactive query editing (see more https://www.sequelace.com/ )? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask sequel-ace
    echo "\n"
fi

REPLY=''
echo -n "Would you like to install iterm2 to replace the macOS terminal? (see https://iterm2.com/ for reference on features)? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask iterm2
    echo "\n"
fi

REPLY=''
echo -n "Would you like to install oh-my-zsh for command line helper functions (see https://ohmyz.sh/)? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install zsh zsh-completions zsh-syntax-highlighting
    echo "\n"
fi

REPLY=''
echo -n "Would you like to install git for version control? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew instal git
    brew install gh
    echo "\n"
fi

REPLY=''
echo -n "Would you like to install postman for testing/accessing of APIs (see https://www.postman.com/ )? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install --cask postman
    echo "\n"
fi

REPLY=''
echo -n "Would you like to install docker and docker compose for running containerized apps and development environments (see https://docs.docker.com/engine/ )? (y/n):  "
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

REPLY=''
echo -n "Would you like to download+add the suggested (appearance) customizations for iterm2? (y/n):  "
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then    
    # Optional mods for iterm2
    pushd $HOME/Documents/
    
    # Gets some fun features that shows you current git branch etc. Need to activate by adding this into ~/.zshrc
    git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    popd

    append_to_zshrc '# Sets a theme for iterm2 that detects and displays the git branch and status of working directory
ZSH_THEME="powerlevel10k/powerlevel10k"'

    append_to_zshrc '# Once powerlevel10k is installed and activated, this activates the version control features
POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)'

    append_to_zshrc '# This shows the status, background jobs and history time
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)'

fi

REPLY=''
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
              echo '\n'
fi
        echo '\n'
fi
}
"
fi
