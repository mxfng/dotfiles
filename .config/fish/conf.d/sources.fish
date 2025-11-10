# Homebrew
test -e /opt/homebrew/bin/brew
and /opt/homebrew/bin/brew shellenv | source

# ASDF
test -e "(brew --prefix asdf)"/libexec/asdf.fish
and source "(brew --prefix asdf)"/libexec/asdf.fish
and mkdir -p ~/.config/fish/completions
and ln -sf "(brew --prefix asdf)"/completions/asdf.fish ~/.config/fish/completions # ensure completions are available

# Tool integrations
command -q starship; and starship init fish | source
command -q zoxide; and zoxide init fish | source
command -q fzf; and fzf --fish | source
command -q pyenv; and pyenv init - | source
