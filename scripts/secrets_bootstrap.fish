#!/usr/bin/env fish

source (dirname (status filename))/../.config/fish/functions/log.fish
source (dirname (status filename))/../.config/fish/functions/confirm.fish

function __bws_set_keychain -a service value
    if not security find-generic-password -s $service >/dev/null 2>&1
        security add-generic-password -a $USER -s $service -w $value
        echo "cached $service to keychain"
    end
end

log "setting up bws cli and secrets"

if not command -q bws
    log "installing bws"
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

# resolve secrets from BWS to Keychain
set -l bws_token (security find-generic-password -w -s bws-access-token 2>/dev/null)

if command -q bws; and test -n "$bws_token"
    set -gx BWS_ACCESS_TOKEN $bws_token

    # These are not usable API keys here; they are UUIDs corresponding to bitwarden secrets
    # Stash any useful UUIDs for secrets you need on any bootstrapped machine here
    set -l secrets \
        anthropic-api-key 1a3187c3-fa93-4c07-b0b3-b4780146cf06 \
        deepseek-api-key 7de096b6-1e06-40df-8e43-b4780122d49f

    for i in (seq 1 2 (count $secrets))
        set -l service $secrets[$i]
        set -l uuid $secrets[(math $i + 1)]
        set -l value (bws secret get $uuid 2>/dev/null | jq -r .value)
        if test -n "$value"
            __bws_set_keychain $service $value
        else
            echo "warning: could not resolve $service from bws"
        end
    end
end
