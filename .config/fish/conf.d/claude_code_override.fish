# Override Claude Code backend. Secrets fetched from Bitwarden via bws_setup.fish.

set -gx BWS_ACCESS_TOKEN (security find-generic-password -w -s bws-access-token 2>/dev/null)

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
