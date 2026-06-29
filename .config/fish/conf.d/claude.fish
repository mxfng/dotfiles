if not set -q CLAUDE_CODE_BACKEND
    set -U CLAUDE_CODE_BACKEND deepseek
end
claude-use $CLAUDE_CODE_BACKEND
