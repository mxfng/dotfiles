if status is-interactive
    # system
    abbr --add cat 'bat -pp'
    abbr --add cl clear
    abbr --add fromcb pbpaste
    abbr --add siz 'du -khsc'
    abbr --add tocb pbcopy
    abbr --add usebash 'chsh -s $(which bash)'
    abbr --add usefish 'chsh -s $(which fish)'
    abbr --add usezsh 'chsh -s $(which zsh)'

    # apps
    abbr --add zen 'open -a Zen'

    # files
    abbr --add grabit 'wget -mkEpnp'
    abbr --add lzip 'ouch list'
    abbr --add rcp 'rsync -aP'
    abbr --add symlink 'ln -s'
    abbr --add unzip 'ouch decompress'
    abbr --add zip 'ouch compress -q'

    # git
    abbr --add aa 'git add --all'
    abbr --add add 'git add'
    abbr --add amend 'git commit --amend'
    abbr --add au 'git add -u'
    abbr --add branch 'git branch'
    abbr --add checkout 'git checkout'
    abbr --add --set-cursor cm 'git commit -m "%"'
    abbr --add --set-cursor cma 'git commit -am "%"'
    abbr --add co 'git checkout'
    abbr --add --set-cursor commit 'git commit -m "%"'
    abbr --add fa 'git fetch --all'
    abbr --add fetch "git fetch"
    abbr --add fuckit 'git reset --hard && git clean -df'
    abbr --add g git
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

    # ssh
    abbr --add ssh-add-key 'ssh-add --apple-use-keychain ~/.ssh/id_ed25519'
    abbr --add ssh-rm 'ssh-keygen -f ~/.ssh/known_hosts -R'

    # tools
    abbr --add cc claude
    abbr --add d docker
    abbr --add dc 'docker compose'
    abbr --add find fd
    abbr --add grep rg
    abbr --add k kubectl
    abbr --add oc opencode
    abbr --add psql pgcli
    abbr --add tar ouch
    abbr --add top btop
    abbr --add vi nvim
    abbr --add vim nvim
end
