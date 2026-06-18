function gwt --description 'Standardized git worktree helper (agentic-coding friendly)'
    # Worktrees live under a central, predictable root so the layout is
    # identical on every machine: $GWT_HOME/<repo>/<sanitized-branch>
    set -q GWT_HOME; or set -l GWT_HOME "$HOME/worktrees"

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "gwt: not inside a git repository" >&2
        return 1
    end

    # Resolve the repo's primary worktree (main checkout), and its name.
    set -l main_root (git worktree list --porcelain | string match -rg '^worktree (.+)' | head -1)
    set -l repo (basename $main_root)
    set -l base "$GWT_HOME/$repo"

    set -l cmd $argv[1]
    set -l rest $argv[2..-1]

    switch "$cmd"
        case add a
            if test -z "$rest[1]"
                echo "usage: gwt add <branch> [base-ref]" >&2
                return 1
            end
            set -l branch $rest[1]
            set -l dir "$base/"(string replace --all / - $branch)

            if test -d "$dir"
                echo "gwt: worktree already exists at $dir" >&2
                cd "$dir"; and return 0
                return 1
            end
            mkdir -p "$base"

            if git show-ref --verify --quiet "refs/heads/$branch"
                # Existing local branch.
                git worktree add "$dir" "$branch"; or return 1
            else
                # New branch, forked from given ref (default: current HEAD).
                set -l from $rest[2]
                test -z "$from"; and set from HEAD
                git worktree add -b "$branch" "$dir" "$from"; or return 1
            end
            cd "$dir"

        case cd c
            if test -z "$rest[1]"
                # No arg: pick interactively.
                if not command -q fzf
                    echo "gwt: fzf not installed; pass a branch name" >&2
                    return 1
                end
                set -l pick (git worktree list | fzf | string split -f1 ' ')
                test -n "$pick"; and cd "$pick"
                return
            end
            set -l dir "$base/"(string replace --all / - $rest[1])
            if test -d "$dir"
                cd "$dir"
            else
                echo "gwt: no worktree for '$rest[1]' (try: gwt list)" >&2
                return 1
            end

        case list ls l ''
            git worktree list

        case rm remove r
            if test -z "$rest[1]"
                echo "usage: gwt rm <branch>" >&2
                return 1
            end
            set -l branch $rest[1]
            set -l dir "$base/"(string replace --all / - $branch)
            if not test -d "$dir"
                echo "gwt: no worktree at $dir" >&2
                return 1
            end
            if confirm "Remove worktree $dir? (y/N)" N
                # If we're standing in it, step out first.
                string match -q "$dir*" (pwd); and cd "$main_root"
                git worktree remove "$dir"
                and echo "Removed $dir"
            else
                echo "Cancelled."
            end

        case prune p
            git worktree prune -v

        case root
            echo "$base"

        case '*'
            echo "gwt: unknown command '$cmd'" >&2
            echo "usage: gwt {add|cd|list|rm|prune|root}" >&2
            return 1
    end
end
