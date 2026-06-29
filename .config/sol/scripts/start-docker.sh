#!/usr/bin/env bash
# name: Start Docker
# icon: 🐳

# Sol runs scripts via a non-login bash, so Homebrew's bin is not on PATH.
export PATH="/opt/homebrew/bin:$PATH"

colima start
