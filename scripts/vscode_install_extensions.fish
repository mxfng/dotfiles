#!/usr/bin/env fish

# Install VSCode extensions from extensions.txt

set -l extensions_file (dirname (status -f))/../.config/code/extensions.txt

if not test -f $extensions_file
    echo "error: no extensions file found at $extensions_file"
    exit 1
end

if not command -q code
    echo 'error: code CLI not found'
    exit 1
end

echo 'installing vscode extensions'

while read extension
    code --install-extension $extension >/dev/null 2>&1
end <$extensions_file
