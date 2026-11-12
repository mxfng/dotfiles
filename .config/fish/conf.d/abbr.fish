if status is-interactive
    # system
    abbr --add cat 'bat -pp'

    # clipboard
    abbr --add tocb pbcopy

    # files
    abbr --add symlink 'ln -s'
    abbr --add unzip 'ouch decompress'

    # git
    abbr --add aa 'git add --all'
    abbr --add add 'git add'
    abbr --add amend 'git commit --amend'
    abbr --add au 'git add -u'
    abbr --add br 'git branch'
    abbr --add branch 'git branch'
    abbr --add checkout 'git checkout'
    abbr --add --set-cursor cm 'git commit -m "%"'
    abbr --add co 'git checkout'
    abbr --add --set-cursor commit 'git commit -m "%"'
    abbr --add fetch "git fetch"
    abbr --add fuckit 'git reset --hard && git clean -df'
    abbr --add g git
    abbr --add gbc git_branch_cleanup
    abbr --add gd 'git diff'
    abbr --add pull 'git pull'
    abbr --add push 'git push'
    abbr --add rb 'git rebase'
    abbr --add sco 'git restore --staged'
    abbr --add st 'git status'
    abbr --add stash 'git stash'

    # tools
    abbr --add cc claude
    abbr --add find fd
    abbr --add grep rg
    abbr --add tar ouch
    abbr --add vi nvim
    abbr --add vim nvim
end
