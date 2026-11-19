#!/usr/bin/env fish

# Install the default language runtimes from ~/.tool-versions.
# Tools such as mason run outside any project and use these versions.

source (dirname (status filename))/../.config/fish/functions/ohai.fish
source (dirname (status filename))/../.config/fish/conf.d/env.fish

ohai 'installing language runtimes'

for tool in (awk '{ print $1 }' ~/.tool-versions)
    asdf plugin add $tool
    or echo "warning: failed to add asdf plugin $tool"
end

pushd ~
asdf install
or echo 'warning: failed to install asdf runtimes'
popd
