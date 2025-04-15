# Running Cursor with nvim

Before attempting to confure Cursor with Neovim, ensure you have installed all the dependencies.

You can do this quickly by running the sync script from the dotfiles directory
```bash
./sync -d
```

To get started, install VSCode Neovim from Extensions

You can get to Cursor's settings in Application Support folder
```bash
nvim ~/Library/Application\ Support/Cursor/User/settings.json
```

Update settings.json with
```json
"vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim"
```

Then, run the following commands
```bash
defaults delete -g ApplePressAndHoldEnabled
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.cursor.Cursor ApplePressAndHoldEnabled -bool false
```

Go to System Settings > Keyboard and update Key repeat rate to 6/7 and Delay until repeat to 4/5.

Log out, log back in and restart Cursor. If this script was successful, you should be able to press and hold your h,j,k,l keys to navigate with VSCode Neovim enabled.
