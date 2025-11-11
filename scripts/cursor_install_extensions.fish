#!/usr/bin/env fish

# Install Cursor extensions from extensions.txt

set -l extensions_file (dirname (status -f))/../.config/cursor/extensions.txt

if not test -f $extensions_file
    echo "error: no extensions file found at $extensions_file"
    exit 1
end

if not command -q cursor
    echo 'error: cursor CLI not found'
    exit 1
end

echo 'installing cursor extensions'

while read extension
    cursor --install-extension $extension >/dev/null 2>&1
end <$extensions_file
