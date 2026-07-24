function claude_account
    argparse quiet -- $argv
    or return 1

    set -l accounts personal personal2 work
    set -l account $argv[1]

    # No account given: at startup (--quiet) reapply the saved one if opted in;
    # otherwise prompt with it preselected.
    if test -z "$account"
        if set -q _flag_quiet
            set -q CLAUDE_ACCOUNT; or return 0
            set account $CLAUDE_ACCOUNT
        else
            set -l default personal
            set -q CLAUDE_ACCOUNT; and set default $CLAUDE_ACCOUNT
            log "select a Claude Code account"
            set account (gum choose --header "" --no-show-help --cursor.foreground 4 --selected.foreground 4 --selected "$default" $accounts)
            test -z "$account"; and return 0
        end
    end

    if not contains -- "$account" $accounts
        echo "Usage: claude_account [--quiet] [personal|personal2|work]"
        return 1
    end

    __claude_account_scaffold $account
    or return 1

    set -U CLAUDE_ACCOUNT $account
    set -gx CLAUDE_CONFIG_DIR "$HOME/.claude-$account"
    # interactive auth ignores CLAUDE_CODE_OAUTH_TOKEN; clear it to dodge the warning
    set -e CLAUDE_CODE_OAUTH_TOKEN

    set -q _flag_quiet; or echo "using account $account"
end

# Build ~/.claude-<account> from symlinks into the shared ~/.claude base so
# accounts share settings, skills, and history and only the login differs.
function __claude_account_scaffold --argument-names account
    set -l base "$HOME/.claude"
    set -l dir "$HOME/.claude-$account"

    test -d "$base"; or begin
        echo "error: shared base $base not found" >&2
        return 1
    end

    mkdir -p "$dir"

    set -l shared settings.json CLAUDE.md plugins commands agents skills \
        projects history.jsonl sessions todos file-history

    for item in $shared
        test -e "$base/$item"; or continue
        set -l link "$dir/$item"
        test -L "$link"; and continue
        test -e "$link"; and continue
        ln -s "$base/$item" "$link"
    end
end
