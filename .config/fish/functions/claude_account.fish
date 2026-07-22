# Switch the active Claude Code subscription account by pointing
# CLAUDE_CONFIG_DIR at a per-account dir (~/.claude-<account>). Each dir shares
# settings, skills, and history with the base ~/.claude via symlinks; only the
# login differs -- macOS isolates it per config dir, so each account keeps its
# own /login. The dir is scaffolded lazily the first time you pick an account.
# Choice persists in CLAUDE_ACCOUNT and is reapplied at shell start by
# conf.d/claude.fish. Interactive-mode auth ignores CLAUDE_CODE_OAUTH_TOKEN, so
# this uses real per-dir logins rather than a swapped token.
# Usage:
#   claude_account [--quiet] [personal|personal2|work]
function claude_account
    argparse quiet -- $argv
    or return 1

    set -l accounts personal personal2 work
    set -l account $argv[1]

    # No account given: at startup (--quiet) reapply the saved one, but only if
    # account switching has been opted into; otherwise prompt with it preselected.
    if test -z "$account"
        if set -q _flag_quiet
            set -q CLAUDE_ACCOUNT; or return 0
            set account $CLAUDE_ACCOUNT
        else
            set -l default personal
            set -q CLAUDE_ACCOUNT; and set default $CLAUDE_ACCOUNT
            log "select a Claude Code account"
            set account (gum choose --header "" --no-show-help --cursor.foreground 4 --selected.foreground 4 --selected "$default" $accounts)
            # Cancelled (esc / ctrl-c) -- leave the current config untouched.
            test -z "$account"; and return 0
        end
    end

    if not contains -- "$account" $accounts
        echo "Usage: claude_account [--quiet] [personal|personal2|work]"
        return 1
    end

    # Build the per-account config dir on first pick (idempotent thereafter).
    __claude_account_scaffold $account
    or return 1

    set -U CLAUDE_ACCOUNT $account
    set -gx CLAUDE_CONFIG_DIR "$HOME/.claude-$account"
    # Interactive auth lives in the config dir's login; clear any stale headless
    # OAuth token so it doesn't trigger the dual-auth warning.
    set -e CLAUDE_CODE_OAUTH_TOKEN

    set -q _flag_quiet; or echo "using account $account (run 'claude /login' once if it prompts)"
end

# Idempotently build ~/.claude-<account> as symlinks into the shared base
# (~/.claude) so every account shares settings, skills, and history and only the
# login differs. Safe to re-run; adds any newly-shareable base items on later
# picks and never clobbers a real per-account file. Usage: internal helper.
function __claude_account_scaffold --argument-names account
    set -l base "$HOME/.claude"
    set -l dir "$HOME/.claude-$account"

    test -d "$base"
    or begin
        echo "error: shared base $base not found" >&2
        return 1
    end

    mkdir -p "$dir"

    # Shared across all accounts: config, global instructions, skills, and the
    # full session history (so personal/personal2/work see the same projects).
    set -l shared settings.json CLAUDE.md plugins commands agents \
        projects history.jsonl sessions todos file-history

    for item in $shared
        test -e "$base/$item"; or continue    # nothing to link
        set -l link "$dir/$item"
        test -L "$link"; and continue          # already linked (even if dangling)
        test -e "$link"; and continue          # a real per-account file lives here
        ln -s "$base/$item" "$link"
    end
end
