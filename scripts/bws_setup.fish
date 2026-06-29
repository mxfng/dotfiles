#!/usr/bin/env fish

source ./.config/fish/functions/log.fish
source ./.config/fish/functions/confirm.fish

if not confirm "Set up Bitwarden Secrets CLI? [y/N]" N
    exit 0
end

# --- install ---
if not command -q bws
    switch (uname)
        case Darwin
            set arch aarch64-apple-darwin
        case Linux
            set arch x86_64-unknown-linux-gnu
    end

    mkdir -p $HOME/.local/bin
    curl -fsSL https://github.com/bitwarden/sdk-sm/releases/download/bws-v2.1.0/bws-$arch-2.1.0.zip -o /tmp/bws.zip
    unzip -oq /tmp/bws.zip -d $HOME/.local/bin
    chmod +x $HOME/.local/bin/bws
    rm -f /tmp/bws.zip
    log "bws installed"
end

# --- auth ---
if not security find-generic-password -s bws-access-token >/dev/null 2>&1
    echo
    echo "  Create an access token at https://vault.bitwarden.com/#/sm"
    echo "  (Machine Accounts → Access Tokens)"
    echo
    read -P "  Paste BWS_ACCESS_TOKEN: " -s token
    echo
    test -n "$token"
    and security add-generic-password -a $USER -s bws-access-token -w $token
    or echo "warning: skipped bws token"
end

# --- provider secret UUIDs ---
# Not secrets — just row IDs. Create the actual secret in the web vault first,
# then paste its UUID here. Re-run provision when adding new providers.

security add-generic-password -a $USER -s claude-code-backend-secret-id -w 7de096b6-1e06-40df-8e43-b4780122d49f
# security add-generic-password -a $USER -s openai-secret-id        -w <uuid>
# security add-generic-password -a $USER -s anthropic-secret-id     -w <uuid>

log "done setting up Bitwarden Secrets CLI"
