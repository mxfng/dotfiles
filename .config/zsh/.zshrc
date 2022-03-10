# mxfng.zshrc | Zsh-Specific Configuration File.

# Colorize + Change prompt
autoload -U colors && colors
source $ZDOTDIR/prompt     # Import prompt config
setopt autocd		        # Automatically cd into typed directory.
stty stop undef		        # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in .cache Directory
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=$CACHE_HOME/zsh/history
setopt appendhistory

# Load Aliases/Shortcuts
[ -f "${CONFIG_HOME}/shell/shortcutrc" ] && source "${CONFIG_HOME}/shell/shortcutrc"
[ -f "${CONFIG_HOME}/shell/aliasrc" ] && source "${CONFIG_HOME}/shell/aliasrc"

# Simple Auto/Tab Complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $CACHE_HOME/zsh/.zcompdump      # Outputs to $HOME
_comp_options+=(globdots)		        # Include hidden files 


# Use lf to switch directories + Bind to Ctrl+G
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^g' 'lfcd\n'

# NVM
source $(brew --prefix nvm)/nvm.sh

# iTerm2 Shell Integration
source $CONFIG_HOME/iTerm2/.iterm2_shell_integration.zsh

# Auto-Suggestions
source $HOMEBREW_PREFIX/Cellar/zsh-autosuggestions/0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting (Should Be Last)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh