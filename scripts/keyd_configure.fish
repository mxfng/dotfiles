#!/usr/bin/env fish

log "setting up keyd"

if not command -q keyd
    echo 'error: keyd is not installed (paru -S keyd)'
    exit 1
end

sudo mkdir -p /etc/keyd

# Remap Right Alt (AltGr) to Super for macOS-like right-hand modifier access.
# System-level config, requires sudo. Safe to re-run.

echo '[ids]
*

[main]
rightalt = leftmeta
rightcontrol = leftalt' | sudo tee /etc/keyd/default.conf >/dev/null
or exit 1

sudo systemctl enable --now keyd
or exit 1

log "keyd configured — right alt=super, right ctrl=alt"
