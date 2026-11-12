function git_cleanup --description 'Pick branches and worktrees to delete'
    set -l base (git rev-parse --abbrev-ref --verify -q origin/HEAD; or echo main)
    git fetch --prune --quiet origin 2>/dev/null
    git worktree prune # forget worktrees whose folder was deleted
    set -l merged (git branch --format='%(refname:short)' --merged $base)
    set -l current (git branch --show-current)

    # rows hold "branch<tab>worktree path" for deleting; labels are what fzf shows
    set -l rows
    set -l labels
    for line in (git for-each-ref refs/heads \
            --format='%(refname:short)%09%(worktreepath)%09%(upstream:track)%09%(committerdate:relative)')
        set -l f (string split \t -- $line) # branch, worktree path, upstream state, age
        test "$f[1]" = (string replace origin/ '' $base); or test "$f[1]" = "$current"; and continue

        set -l notes $f[4]
        contains -- $f[1] $merged; and set -a notes merged
        test "$f[3]" = '[gone]'; and set -a notes 'remote gone'
        test -n "$f[2]"; and test -n "$(git -C $f[2] status --porcelain)"; and set -a notes dirty

        set -a rows "$f[1]"\t"$f[2]"
        set -a labels (printf '%-32s %-34s %s' $f[1] (string join ', ' $notes) (string replace (pwd)/ '' "$f[2]"))
    end
    # Worktrees with no branch (detached HEAD)
    for p in (git worktree list | string match '*(detached HEAD)' | string split -f1 ' ')
        set -l notes detached
        test -n "$(git -C $p status --porcelain)"; and set -a notes dirty
        set -a rows \t$p
        set -l head (git -C $p rev-parse --short HEAD) # shown in place of a branch name
        set -a labels (printf '%-32s %-34s %s' $head (string join ', ' $notes) (string replace (pwd)/ '' $p))
    end

    if test (count $rows) -eq 0
        echo 'nothing to clean'
        return 0
    end
    # The preview shows the commits each branch has that the base branch does not
    set -l preview "git log --oneline --color=always $base..{1} | grep . || echo 'no commits beyond $base'"
    set -l picked (printf '%s\n' $labels | fzf -m --preview=$preview --preview-window=right,40%)
    if test -z "$picked"
        echo 'nothing selected'
        return 0
    end

    echo "you're about to delete:"
    set_color red
    printf '  %s\n' $picked
    set_color normal
    confirm 'are you sure? [y/N]' N; or return 0

    for label in $picked
        set -l f (string split \t -- $rows[(contains -i -- $label $labels)]) # branch, worktree path
        # git refuses to remove a worktree with uncommitted changes, so dirty ones are safe
        test -n "$f[2]"; and begin
            git worktree remove $f[2]; or continue
        end
        test -n "$f[1]"; and git branch -D $f[1]
    end
    git worktree prune
end
