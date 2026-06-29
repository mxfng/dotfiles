function claude_use --argument-names backend
    set -l backends deepseek anthropic
    if not contains "$backend" $backends
        echo "Usage: claude-use [deepseek|anthropic]"
        return 1
    end

    set -U CLAUDE_CODE_BACKEND $backend

    # Clear all Claude Code env vars
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

    # Fetch auth from Bitwarden Secrets
    set -gx BWS_ACCESS_TOKEN (security find-generic-password -w -s bws-access-token 2>/dev/null)

    set -l oauth_id (security find-generic-password -w -s claude-code-oauth-token 2>/dev/null)
    set -l oauth_token
    if command -q bws; and test -n "$BWS_ACCESS_TOKEN"; and test -n "$oauth_id"
        set oauth_token (bws secret get $oauth_id 2>/dev/null | jq -r .value)
    end

    switch "$backend"
        case deepseek
            if test -n "$oauth_token"
                set -gx CLAUDE_CODE_OAUTH_TOKEN $oauth_token
            end
            set -l secret_id (security find-generic-password -w -s claude-code-backend-secret-id 2>/dev/null)
            if command -q bws; and test -n "$BWS_ACCESS_TOKEN"; and test -n "$secret_id"
                set -gx ANTHROPIC_AUTH_TOKEN (bws secret get $secret_id 2>/dev/null | jq -r .value)
            end
            set -gx ANTHROPIC_BASE_URL https://api.deepseek.com/anthropic
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL deepseek-v4-pro[1m]
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_SUBAGENT_MODEL deepseek-v4-flash
            set -gx CLAUDE_CODE_EFFORT_LEVEL max
        case anthropic
            if test -n "$oauth_token"
                set -gx ANTHROPIC_AUTH_TOKEN $oauth_token
            end
    end

    # echo "Claude Code → $backend"
end
