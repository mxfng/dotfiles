if status is-interactive
    # System & Utilities
    abbr --add cl clear
    abbr --add cw center_window
    abbr --add cat 'bat -pp'
    abbr --add q exit
    abbr --add siz 'du -khsc'
    abbr --add usefish 'chsh -s $(which fish)'
    abbr --add usebash 'chsh -s $(which bash)'
    abbr --add usezsh 'chsh -s $(which zsh)'

    # Clipboard
    abbr --add fromcb pbpaste
    abbr --add tocb pbcopy

    # Homebrew
    abbr --add bi 'brew install '
    abbr --add binfo 'brew info'
    abbr --add brews 'brew list'
    abbr --add casks 'brew list --cask'
    abbr --add bic --set-cursor 'brew install % --cask'

    # Editors & Terminals
    abbr --add vim nvim
    abbr --add nv nvim
    abbr --add wez wezterm
    abbr --add co code
    abbr --add con 'code -n .'
    abbr --add coo 'code -r .'
    abbr --add c cursor
    abbr --add zen 'open -a Zen'

    # Git
    abbr --add g git
    abbr --add gd 'git diff'
    abbr --add co 'git checkout'
    abbr --add --set-cursor cob 'git checkout -b'
    abbr --add aa 'git add --all'
    abbr --add br 'git branch'
    abbr --add --set-cursor cm 'git commit -m "%"'
    abbr --add --set-cursor cma 'git commit -am "%"'
    abbr --add push 'git push'
    abbr --add pf 'git push --force'
    abbr --add pa 'git push --all'
    abbr --add pfwl 'git push --force-with-lease'
    abbr --add pull 'git pull'
    abbr --add puff 'git pull --ff-only'
    abbr --add fa 'git fetch --all'
    abbr --add rb 'git rebase'
    abbr --add sco 'git restore --staged'
    abbr --add st 'git status'
    abbr --add sts 'git stash'
    abbr --add sta 'git stash apply'
    abbr --add pop 'git stash pop'
    abbr --add rh 'git reset --hard'

    # Docker
    abbr --add d docker
    abbr --add dc 'docker compose'

    # Kubernetes & Cloud
    abbr --add k kubectl
    abbr --add gco 'gcloud compute'

    # Terraform
    abbr --add tf terraform

    # File Operations
    abbr --add rcp 'rsync -aP'
    abbr --add link 'ln -s'
    abbr --add symlink 'ln -s'
    abbr --add zip 'ouch compress -q'
    abbr --add unzip 'ouch decompress'
    abbr --add lzip 'ouch list'
    abbr --add grabit 'wget -mkEpnp url_here'

    # SSH
    abbr --add ssh-rm 'ssh-keygen -f ~/.ssh/known_hosts -R'
    abbr --add ssh-add-key 'ssh-add --apple-use-keychain ~/.ssh/id_ed25519'

    # Directories & Paths
    abbr --add config '~/.config/'
    abbr --add local '~/.local/'
    abbr --add dls '~/Downloads/'
    abbr --add goo 'cd ~/.go/'

    # Tools
    abbr --add npms 'npm list -g --depth=0'
    abbr --add buns 'bun pm ls -g'

    # Development
    abbr --add lh 'lighthouse --output=html --output-path ~/Developer/Lighthouse-Audits/ https://'
    abbr --add wrg wrangler

    # Terminal Multiplexers
    abbr --add tm tmux
    abbr --add amux 'tmux at -t base'
    abbr --add tkill 'tmux kill-session -t'
    abbr --add nmux 'tmux new -s "base"'

    # AI Agents + Models
    abbr --add cc claude

    abbr lsa "ls -a"
end
