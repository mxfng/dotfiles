#!/usr/bin/env fish

# Setup yabai scripting addition with passwordless sudo

set yabai_path (which yabai)

if test -z "$yabai_path"
    echo 'error: could not find yabai'
    exit 1
end

set username (whoami)
set sudoers_file /etc/sudoers.d/yabai

# Configure passwordless sudo for yabai --load-sa
set yabai_hash (shasum -a 256 $yabai_path | cut -d " " -f 1)
set expected_entry "$username ALL=(root) NOPASSWD: sha256:$yabai_hash $yabai_path --load-sa"

if not test -f $sudoers_file; or not sudo grep -qF "$yabai_hash" $sudoers_file
    echo 'configuring passwordless sudo for yabai --load-sa'
    echo $expected_entry | sudo tee $sudoers_file >/dev/null

    if not sudo visudo -c -f $sudoers_file &>/dev/null
        echo 'error: invalid sudoers file'
        sudo rm $sudoers_file
        exit 1
    end
end

# Install scripting addition
sudo yabai --uninstall-sa 2>/dev/null; or true
sudo yabai --load-sa

echo 'scripting addition setup complete, test with: yabai -m space --focus next'
