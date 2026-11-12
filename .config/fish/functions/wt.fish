function wt --description 'Pick a worktree and cd into it'
    set -l rows
    for line in (git worktree list --porcelain)
        switch $line
            case 'worktree *'
                set -a rows (string sub -s 10 -- $line)\t'(detached)'
            case 'branch *'
                set rows[-1] (string split -f1 \t -- $rows[-1])\t(string replace 'branch refs/heads/' '' -- $line)
        end
    end

    set -l dir (printf '%s\n' $rows | fzf --delimiter=\t --preview 'git -C {1} log --oneline --color=always -10' | string split -f1 \t)
    test -n "$dir"; and cd $dir
end
