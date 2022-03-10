# mxfng.sync | Run to sync dotfiles to $HOME and brew bundle.

BASEDIR="$(dirname "$(realpath -s "$0")")"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo Syncing mxfng.dotfiles.macOS

    which -s brew
    if [[ $? != 0 ]] ; then
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        brew update
    fi

    brew bundle --file=$BASEDIR/Brewfile    # Run Brewfile
    
    if [ $(which zsh) != "$(brew --prefix)/bin/zsh"]; then
        echo Current active Zsh will swap to $(which zsh)
        chsh -s $(which zsh)   # Set Default Shell to Homebrew Zsh
    fi
    
    # iTerm2 Shell Integration for Zsh
    curl -L https://iterm2.com/shell_integration/zsh \
    -o $BASEDIR/.config/iTerm2/.iterm2_shell_integration.zsh
    touch ~/.hushlogin      # Silence prompt at login

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

# ~/ Setup
mkdir -p ~/.cache/zsh ~/.nvm ~/Developer 

echo 'Refresh your shell to reflect sync or run `source ~/.zprofile ~/.zshrc`'

echo Synced mxfng.dotfiles