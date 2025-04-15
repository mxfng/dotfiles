# Installing yabai scripting addons

This enables management of spaces using yabai.

```bash
# reboot into recovery

csrutil disable

# reboot

sudo nvram boot-args=-arm64e_preview_abi

# reboot

sudo yabai --uninstall-sa
sudo yabai --load-sa

# test if scripting addons working
# create a second desktop on macOS if needed
yabai -m space --focus next
```

