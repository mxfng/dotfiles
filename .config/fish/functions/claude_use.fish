function claude_use --argument-names backend
    set -l backends deepseek anthropic
    if not contains "$backend" $backends
        echo "Usage: claude-use [deepseek|anthropic]"
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
    set -e BWS_ACCESS_TOKEN

    # Pull secrets from Keychain (run provision first; stored by secrets_bootstrap)
    set -gx BWS_ACCESS_TOKEN (security find-generic-password -w -s bws-access-token 2>/dev/null)

    switch "$backend"
        case deepseek
            set -gx CLAUDE_CODE_OAUTH_TOKEN (security find-generic-password -w -s anthropic-api-key 2>/dev/null)
            set -gx ANTHROPIC_AUTH_TOKEN (security find-generic-password -w -s deepseek-api-key 2>/dev/null)
            set -gx ANTHROPIC_BASE_URL https://api.deepseek.com/anthropic
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_SUBAGENT_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_EFFORT_LEVEL max
        case anthropic
            set -gx ANTHROPIC_AUTH_TOKEN (security find-generic-password -w -s anthropic-api-key 2>/dev/null)
    end
end
