# mxfng.zshrc | Zsh-Specific Configuration File.

# Hush login message

printf '\33c\e[3J'


# Homebrew in PATH

eval "$(/opt/homebrew/bin/brew shellenv)"


# Load Aliases/Shortcuts

[ -f "${CONFIG_HOME}/shell/aliases" ] && source "${CONFIG_HOME}/shell/aliases"
[ -f "${CONFIG_HOME}/shell/scripts" ] && source "${CONFIG_HOME}/shell/scripts"
[ -f $(brew --prefix nvm)/nvm.sh ] && source $(brew --prefix nvm)/nvm.sh


# User defined shell config files from .local/bin/$USER

for f (~/.local/bin/$USER/**/*(N.))  . $f


# Add local bin to path

export PATH="$PATH:/Users/$USER/.local/bin"


# History in .cache Directory

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=$CACHE_HOME/zsh/history
setopt appendhistory


# Auto-Suggestions

source $HOMEBREW_PREFIX/Cellar/zsh-autosuggestions/0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^ " autosuggest-accept


# Simple Auto/Tab Complete

autoload -U compinit && compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $CACHE_HOME/zsh/.zcompdump  # Outputs to $HOME
_comp_options+=(globdots)		        # Include hidden files
zstyle ':completion:*' menu select 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


# Syntax Highlighting

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=117,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=117,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=117


# Colorize + Change prompt

autoload -U colors && colors
source $ZDOTDIR/prompt      # Import prompt config
setopt autocd		        # Automatically cd into typed directory.
stty stop undef		        # Disable ctrl-s to freeze terminal.
setopt interactive_comments


# Append completions to fpath

fpath=(${ASDF_DIR}/completions $fpath)


# iTerm2 Shell Integration

source $CONFIG_HOME/iTerm2/.iterm2_shell_integration.zsh


# ASDF Config

source $(brew --prefix asdf)/libexec/asdf.sh


# SDKMAN - Java/Kotlin dependencies

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"