#!/usr/bin/env fish

set plist_path (skhd --install-service 2>&1 | grep -o '/.*\.plist')

if test -z "$plist_path"
    echo "Could not find the skhd plist path. Is skhd installed?"
    exit 1
end

if not test -f "$plist_path"
    echo "Plist file does not exist at $plist_path"
    exit 1
end

# Use bash to modify the plist since it's more reliable for this task
/bin/bash -c "
    # Check if SHELL is already defined
    if grep -q '<key>SHELL</key>' '$plist_path'; then
        # Update existing SHELL entry
        sed -i '' 's|<string>/bin/.*</string>|<string>/bin/bash</string>|g' '$plist_path'
        echo 'Updated existing SHELL entry in plist'
    else
        # Add SHELL key-value pair after the PATH definition
        if grep -q '<key>EnvironmentVariables</key>' '$plist_path'; then
            sed -i '' '/<key>PATH<\\/key>/,/<\\/string>/ s|</string>|</string>\\n    <key>SHELL</key>\\n    <string>/bin/bash</string>|' '$plist_path'
        else
            # If EnvironmentVariables section doesn't exist, create it before the Program key
            sed -i '' '/<key>Program<\\/key>/ i\\
            <key>EnvironmentVariables</key>\\
            <dict>\\
                <key>PATH</key>\\
                <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>\\
                <key>SHELL</key>\\
                <string>/bin/bash</string>\\
            </dict>\\
            ' '$plist_path'
        fi
    fi
"

echo "Added SHELL=/bin/bash to $plist_path"
