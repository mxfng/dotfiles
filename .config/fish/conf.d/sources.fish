test -e /opt/homebrew/bin/brew
and /opt/homebrew/bin/brew shellenv | source

test -e "(brew --prefix asdf)"/libexec/asdf.fish
and source "(brew --prefix asdf)"/libexec/asdf.fish

command -q fzf; and fzf --fish | source
command -q pyenv; and pyenv init - | source
command -q starship; and starship init fish | source
command -q zoxide; and zoxide init fish | source
