# mxfng.sync | Run to sync dotfiles to $HOME and brew bundle.

BASEDIR=$( dirname $(realpath "$0") )

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo Syncing mxfng.dotfiles.macOS

    brew bundle --file=$BASEDIR/Brewfile    # Run Brewfile
    
    if [ $(which zsh) != "$(brew --prefix)/bin/zsh"]; then
        echo Current active Zsh will swap to $(which zsh)
        chsh -s $(which zsh)   # Set Default Shell to Homebrew Zsh
    fi
    
    # iTerm2 Shell Integration for Zsh
    curl -L https://iterm2.com/shell_integration/zsh \
    -o $BASEDIR/.config/iTerm2/.iterm2_shell_integration.zsh
    touch ~/.hushlogin

    if [[ $(uname -m) == 'arm64' ]]; then
        # M1-Specific Installs
        echo Cleaning up M1 dependencies
    fi

    if [ -e $BASEDIR/Brewfile.lock.json ]; then
        rm $BASEDIR/Brewfile.lock.json   # Wipe Brewfile debugging output
    fi
fi

# Rm sourced .config files to swap in $HOME
if [ -e ~/.zprofile ]; then
    rm ~/.zprofile  # Remove .zprofile in $HOME
fi
if [ -e ~/.zshrc ]; then
    rm ~/.zshrc     # Remove .zshrc in $HOME
fi

# Sourced .config files in $HOME
echo "source ${BASEDIR}/.config/shell/profile" >> ~/.zprofile
echo "source ${BASEDIR}/.config/zsh/.zshrc" >> ~/.zshrc

# Symlinks in $HOME
#ln -s $BASEDIR/.config/git/.gitconfig ~/.gitconfig

# Node Version Manager
if [[ ! -d ~/.nvm ]]; then
    mkdir ~/.nvm
fi

# ~ Setup
mkdir -p ~/.cache
mkdir -p ~/.cache/zsh

echo Synced mxfng.dotfiles