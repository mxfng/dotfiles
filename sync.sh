# mxfng.sync | Run to sync dotfiles to $HOME and brew bundle.

BASEDIR="$(dirname "$(realpath -s "$0")")"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo Syncing mxfng.dotfiles.macOS
fi

cd $BASEDIR; LOCAL_REPO=~/Developer/dotfiles

if [ -d $LOCAL_REPO ] && [ ! -d .git ]; then
    cd $LOCAL_REPO
fi

if [ -d .git ]; then
    echo Pulling remote
    git pull   # Update Repository
else
    echo Cloning remote
    git clone $URL $LOCAL_REPO
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    which -s brew
    if [[ $? != 0 ]] ; then
        echo Installing Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    echo Running Brewfile
    brew update; brew bundle --file=$BASEDIR/Brewfile    # Run Brewfile
    
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

    rm -f $BASEDIR/Brewfile.lock.json   # Wipe Brewfile debugging output
fi

# Rm .config files to swap in $HOME
for DOTFILE in ~/.zprofile ~/.zshrc ~/.gitconfig; do
    rm -f $DOTFILE
done

# Source .config files in $HOME
echo "source ${BASEDIR}/.config/shell/profile" >> ~/.zprofile
echo "source ${BASEDIR}/.config/zsh/.zshrc" >> ~/.zshrc

# Symlink .config files in $HOME
ln -s $BASEDIR/.config/git/.gitconfig ~/.gitconfig

# ~/ Setup
mkdir -p ~/.cache/zsh ~/.nvm ~/Developer 

echo 'Refresh your shell to reflect sync or run `source ~/.zprofile ~/.zshrc`'

echo Synced mxfng.dotfiles