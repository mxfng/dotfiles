#!/usr/bin/env fish

# Setup yabai scripting addition with passwordless sudo

set yabai_path (which yabai)

if test -z "$yabai_path"
    echo "Could not find yabai. Is it installed?"
    exit 1
end

set username (whoami)
set sudoers_file /etc/sudoers.d/yabai

# Configure passwordless sudo for yabai --load-sa
if not test -f $sudoers_file
    echo "Configuring passwordless sudo for yabai --load-sa..."
    set yabai_hash (shasum -a 256 $yabai_path | cut -d " " -f 1)
    echo "$username ALL=(root) NOPASSWD: sha256:$yabai_hash $yabai_path --load-sa" | sudo tee $sudoers_file >/dev/null

    if not sudo visudo -c -f $sudoers_file &>/dev/null
        echo "Error: Invalid sudoers file"
        sudo rm $sudoers_file
        exit 1
    end
end

# Install scripting addition
sudo yabai --uninstall-sa 2>/dev/null; or true
sudo yabai --load-sa

echo "scripting addition setup complete. test with: yabai -m space --focus next"
