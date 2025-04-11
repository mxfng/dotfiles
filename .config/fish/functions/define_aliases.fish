function define_aliases -a uname -d 'Defines aliases for commonly used commands'
    alias q exit
    alias rcp 'rsync -aP'
    alias tf terraform
    alias gco 'gcloud compute'
    alias tocb 'xclip -in -selection clipboard'
    alias fromcb 'xclip -out -selection clipboard'
    alias ssh-rm 'ssh-keygen -f ~/.ssh/known_hosts -R'
    alias age-p 'age --armor --passphrase'
    alias age-d 'age --decrypt --identity ~/.secrets/id_ed25519'
    alias age-e 'age --armor --recipient (cat ~/.secrets/id_ed25519.pub)'
    alias age-k 'age --decrypt --identity ~/.secrets/id_ed25519 ~/.secrets/age_keys.age'
    alias c cursor
    alias skhdrc 'bat ~/.skhdrc | sed "s/^#.*\$/\x1b[90m&\x1b[0m/" | sed "s/^[^#].*\$/\x1b[32m&\x1b[0m/"'
    alias keys 'curl -sL https://raw.githubusercontent.com/mxfng/dotfiles/main/docs/shortcuts.md | glow -'
end
