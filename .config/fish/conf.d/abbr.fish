if status is-interactive
    # System & Utilities
    abbr --add cl clear
    abbr --add cat 'bat -pp'
    abbr --add siz 'du -khsc'
    abbr --add usefish 'chsh -s $(which fish)'
    abbr --add usebash 'chsh -s $(which bash)'
    abbr --add usezsh 'chsh -s $(which zsh)'

    # Clipboard
    abbr --add fromcb pbpaste
    abbr --add tocb pbcopy

    # Editors & Terminals
    abbr --add vim nvim
    abbr --add zen 'open -a Zen'

    # Git
    abbr --add aa 'git add --all'
    abbr --add add 'git add'
    abbr --add amend 'git commit --amend'
    abbr --add au 'git add -u'
    abbr --add branch 'git branch'
    abbr --add checkout 'git checkout'
    abbr --add --set-cursor cm 'git commit -m "%"'
    abbr --add --set-cursor cma 'git commit -am "%"'
    abbr --add --set-cursor commit 'git commit -m "%"'
    abbr --add co 'git checkout'
    abbr --add fa 'git fetch --all'
    abbr --add fetch "git fetch"
    abbr --add fuckit 'git reset --hard && git clean -df'
    abbr --add gd 'git diff'
    abbr --add lol 'git log --graph --decorate --oneline'
    abbr --add pop 'git stash pop'
    abbr --add puff 'git pull --ff-only'
    abbr --add pull 'git pull'
    abbr --add push 'git push'
    abbr --add rb 'git rebase'
    abbr --add sco 'git restore --staged'
    abbr --add st 'git status'
    abbr --add stash 'git stash'

    # Docker
    abbr --add d docker
    abbr --add dc 'docker compose'

    # Kubernetes & Cloud
    abbr --add k kubectl

    # File Operations
    abbr --add grabit 'wget -mkEpnp'
    abbr --add lzip 'ouch list'
    abbr --add rcp 'rsync -aP'
    abbr --add symlink 'ln -s'
    abbr --add unzip 'ouch decompress'
    abbr --add zip 'ouch compress -q'

    # SSH
    abbr --add ssh-rm 'ssh-keygen -f ~/.ssh/known_hosts -R'
    abbr --add ssh-add-key 'ssh-add --apple-use-keychain ~/.ssh/id_ed25519'

    # AI Agents + Models
    abbr --add cc claude
    abbr --add oc opencode
end
