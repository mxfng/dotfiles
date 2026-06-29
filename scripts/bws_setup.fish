#!/usr/bin/env fish

source ./.config/fish/functions/log.fish
source ./.config/fish/functions/confirm.fish

function __bws_set_keychain -a service value
    if not security find-generic-password -s $service >/dev/null 2>&1
        security add-generic-password -a $USER -s $service -w $value
    end
end

log "setting up bws cli and secrets"

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

if not security find-generic-password -s bws-access-token >/dev/null 2>&1
    echo
    echo "  Create an access token at https://vault.bitwarden.com/#/sm"
    echo "  (Machine Accounts → Access Tokens)"
    echo
    read -P "  Paste BWS_ACCESS_TOKEN: " -s token
    echo
    test -n "$token"
    and __bws_set_keychain bws-access-token $token
    or echo "warning: skipped bws token"
end

# --- provider secret UUIDs ---
__bws_set_keychain claude-code-oauth-token 1a3187c3-fa93-4c07-b0b3-b4780146cf06
__bws_set_keychain claude-code-backend-secret-id 7de096b6-1e06-40df-8e43-b4780122d49f
