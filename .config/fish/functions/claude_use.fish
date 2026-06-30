function claude_use --argument-names backend
    set -l backends deepseek anthropic
    if not contains "$backend" $backends
        echo "Usage: claude_use [deepseek|anthropic]"
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
        case deepseek
            # Anthropic OAuth token is optional in this mode: use it if already
            # cached, but don't prompt for it just to run deepseek.
            set -gx CLAUDE_CODE_OAUTH_TOKEN (security find-generic-password -w -s anthropic-api-key 2>/dev/null)
            set -gx ANTHROPIC_AUTH_TOKEN (__claude_secret deepseek-api-key "DeepSeek API key")
            set -gx ANTHROPIC_BASE_URL https://api.deepseek.com/anthropic
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_SUBAGENT_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_EFFORT_LEVEL max
        case anthropic
            set -gx ANTHROPIC_AUTH_TOKEN (__claude_secret anthropic-api-key "Anthropic API token")
    end
end

# Read a secret from the macOS keychain, prompting once and caching it on first
# use if it isn't there yet. Mirrors how harnesses capture a key on first startup.
function __claude_secret --argument-names service prompt
    set -l val (security find-generic-password -w -s $service 2>/dev/null)
    if test -z "$val"
        read -P "$prompt: " -s val
        echo >&2
        test -n "$val"; and security add-generic-password -a $USER -s $service -w $val >&2
    end
    echo $val
end
