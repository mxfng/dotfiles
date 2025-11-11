#!/usr/bin/env fish

set repo "https://github.com/mirairoad/macos_show_active_workspace.git"
set dir "$HOME/Developer/macos_show_active_workspace/"

if test -d $dir
    echo "Error: Directory $dir already exists. Delete it first if you want a fresh install."
    exit 1
end

echo "cloning macos_show_active_workspace"
git clone $repo $dir; or begin
    echo "Error: Failed to clone repo"
    exit 1
end

cd $dir; or begin
    echo "Error: Failed to cd into $dir"
    exit 1
end

echo "installing..."
chmod +x ./install.sh
./install.sh; or begin
    echo "Error: Install failed"
    exit 1
end
