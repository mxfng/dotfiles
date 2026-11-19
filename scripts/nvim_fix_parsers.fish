#!/usr/bin/env fish

# Fix nvim being killed (exit 137) when it loads a treesitter parser.
#
# A parser update rebuilds each .so in place. macOS keeps the old code
# signature for that file, rejects the new pages, and sends SIGKILL.
# A fresh copy gets a new inode, so macOS checks the signature again.

set -l dir ~/.local/share/nvim/site/parser
test -d $dir; or begin
    echo "no parser directory at $dir"
    exit 1
end

for f in $dir/*.so
    cp -p $f $f.new; and mv -f $f.new $f
    or echo "warning: failed to refresh $f"
end

echo "refreshed "(count $dir/*.so)" parsers in $dir"
