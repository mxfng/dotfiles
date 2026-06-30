function claude_use
    argparse quiet -- $argv
    or return 1

    set -l backends anthropic deepseek
    set -l backend $argv[1]

    # No backend given: at startup (--quiet) just apply the saved choice;
    # otherwise prompt to pick one, with the saved choice preselected.
    if test -z "$backend"
        if set -q _flag_quiet
            set backend $CLAUDE_CODE_BACKEND
            test -z "$backend"; and set backend anthropic
        else
            set -l default anthropic
            set -q CLAUDE_CODE_BACKEND; and set default $CLAUDE_CODE_BACKEND
            log "select a Claude Code provider"
            set backend (gum choose --header "" --no-show-help --cursor.foreground 4 --selected.foreground 4 --selected "$default" $backends)
            # Cancelled (esc / ctrl-c) -- leave the current config untouched.
            test -z "$backend"; and return 0
        end
    end

    if not contains -- "$backend" $backends
        echo "Usage: claude_use [--quiet] [anthropic|deepseek]"
        return 1
    end

    set -U CLAUDE_CODE_BACKEND $backend

    # Clear all
    set -e ANTHROPIC_AUTH_TOKEN
    set -e ANTHROPIC_BASE_URL
    set -e ANTHROPIC_MODEL
    set -e ANTHROPIC_DEFAULT_OPUS_MODEL
    set -e ANTHROPIC_DEFAULT_SONNET_MODEL
    set -e ANTHROPIC_DEFAULT_HAIKU_MODEL
    set -e CLAUDE_CODE_SUBAGENT_MODEL
    set -e CLAUDE_CODE_EFFORT_LEVEL
    set -e CLAUDE_CODE_OAUTH_TOKEN

    switch "$backend"
        case anthropic
            set -gx ANTHROPIC_AUTH_TOKEN (__claude_secret anthropic-api-key "Anthropic API token" $_flag_quiet)
        case deepseek
            # Anthropic OAuth token is optional in this mode: use it if already
            # cached, but don't prompt for it just to run deepseek.
            set -gx CLAUDE_CODE_OAUTH_TOKEN (security find-generic-password -w -s anthropic-api-key 2>/dev/null)
            set -gx ANTHROPIC_AUTH_TOKEN (__claude_secret deepseek-api-key "DeepSeek API key" $_flag_quiet)
            set -gx ANTHROPIC_BASE_URL https://api.deepseek.com/anthropic
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_SUBAGENT_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_EFFORT_LEVEL max
    end

    # Confirm the active provider (skip the silent startup path).
    set -q _flag_quiet; or echo "using $backend"
end

# Read a keychain secret, prompting with gum and caching on first use -- unless
# --quiet (the startup path), which only uses what is already cached.
function __claude_secret --argument-names service prompt quiet
    set -l val (security find-generic-password -w -s $service 2>/dev/null)
    if test -z "$val"; and test -z "$quiet"
        set val (gum input --password --no-show-help \
            --header "$prompt" --header.foreground 4 \
            --cursor.foreground 4 --prompt.foreground 4)
        test -n "$val"; and security add-generic-password -a $USER -s $service -w $val
    end
    echo $val
end
