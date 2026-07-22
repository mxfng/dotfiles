# Pick which account/provider Claude Code bills and authenticates against.
# The Anthropic subscriptions (personal/personal2/work) each carry their own
# OAuth token from `claude setup-token`, cached in the macOS Keychain; deepseek
# routes through its own API key. Choice persists in CLAUDE_CODE_BACKEND /
# CLAUDE_ACCOUNT and is reapplied at shell start by conf.d/claude.fish.
# Usage:
#   claude_use [--quiet] [personal|personal2|work|deepseek]
function claude_use
    argparse quiet -- $argv
    or return 1

    set -l accounts personal personal2 work
    set -l choices $accounts deepseek
    set -l selection $argv[1]

    # The label to preselect / reapply: the deepseek provider, or the remembered
    # Anthropic account (falling back to personal on a fresh machine).
    set -l saved personal
    if test "$CLAUDE_CODE_BACKEND" = deepseek
        set saved deepseek
    else if set -q CLAUDE_ACCOUNT
        set saved $CLAUDE_ACCOUNT
    end

    # No selection given: at startup (--quiet) just apply the saved choice;
    # otherwise prompt to pick one, with the saved choice preselected.
    if test -z "$selection"
        if set -q _flag_quiet
            set selection $saved
        else
            log "select a Claude Code account / provider"
            set selection (gum choose --header "" --no-show-help --cursor.foreground 4 --selected.foreground 4 --selected "$saved" $choices)
            # Cancelled (esc / ctrl-c) -- leave the current config untouched.
            test -z "$selection"; and return 0
        end
    end

    if not contains -- "$selection" $choices
        echo "Usage: claude_use [--quiet] [personal|personal2|work|deepseek]"
        return 1
    end

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

    switch "$selection"
        case deepseek
            set -U CLAUDE_CODE_BACKEND deepseek
            # Anthropic subscription is optional in this mode: keep the remembered
            # account's OAuth token available if already cached, but never prompt.
            if set -q CLAUDE_ACCOUNT
                set -l fallback (security find-generic-password -w -s claude-oauth-$CLAUDE_ACCOUNT 2>/dev/null)
                test -n "$fallback"; and set -gx CLAUDE_CODE_OAUTH_TOKEN $fallback
            end
            set -gx ANTHROPIC_AUTH_TOKEN (__claude_secret deepseek-api-key "DeepSeek API key" $_flag_quiet)
            set -gx ANTHROPIC_BASE_URL https://api.deepseek.com/anthropic
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_SUBAGENT_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_EFFORT_LEVEL max
        case '*'
            # An Anthropic subscription account: authenticate with its OAuth token.
            set -U CLAUDE_CODE_BACKEND anthropic
            set -U CLAUDE_ACCOUNT $selection
            set -l tok (__claude_secret claude-oauth-$selection "OAuth token for $selection (run: claude setup-token)" $_flag_quiet)
            # Leave it unset rather than empty so Claude Code can fall back to its
            # stored login until the token is cached on first interactive use.
            test -n "$tok"; and set -gx CLAUDE_CODE_OAUTH_TOKEN $tok
    end

    # Confirm the active selection (skip the silent startup path).
    set -q _flag_quiet; or echo "using $selection"
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
