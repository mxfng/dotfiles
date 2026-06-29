# Set preferred model provider backend here
if not set -q CLAUDE_CODE_BACKEND
    set -U CLAUDE_CODE_BACKEND deepseek
end
claude_use $CLAUDE_CODE_BACKEND
