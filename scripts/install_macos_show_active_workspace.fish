#!/usr/bin/env fish

set repo "https://github.com/mirairoad/macos_show_active_workspace.git"
set dir "$HOME/Developer/macos_show_active_workspace/"

if test -d $dir
    echo "Directory $dir already exists. Delete it first if you want a fresh install."
    exit 1
end

echo "Cloning macos_show_active_workspace..."
git clone $repo $dir; or begin
    echo "Failed to clone repo."
    exit 1
end

cd $dir; or begin
    echo "Failed to cd into $dir."
    exit 1
end

echo "Installing..."
chmod +x ./install.sh
./install.sh; or begin
    echo "Install failed."
    exit 1
end

echo "Successfully installed macos_show_active_workspace"
