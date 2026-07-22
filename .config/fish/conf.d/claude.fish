# Reapply the machine's saved Claude Code account (config dir) then provider
# (env overlay). Neither prompts at startup -- use `claude_account` to pick an
# account and `claude_use` to pick a provider / set keys. claude_account is a
# no-op until an account has been chosen at least once.
claude_account --quiet
claude_use --quiet
