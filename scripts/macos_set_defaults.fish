#!/usr/bin/env fish

# Set macOS system defaults for developers

echo 'setting macOS defaults'

# Keyboard: disable press-and-hold for key repeat (vim friendly)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keyboard: fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Keyboard: disable auto-correct and smart substitutions
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Keyboard: enable full keyboard access (tab through dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: new windows open to home directory
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Finder: use column view by default
defaults write com.apple.finder FXPreferredViewStyle -string clmv

# Finder: search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# Finder: disable file extension change warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder: keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: avoid creating .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Finder: show ~/Library folder
chflags nohidden ~/Library 2>/dev/null

# Dock: enable auto-hide
defaults write com.apple.dock autohide -bool true

# Dock: don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Dock: don't rearrange spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Prevent Photos from opening automatically
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Menu bar: show clock with 24-hour time and seconds
defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# Spotlight: disable keyboard shortcuts (frees Cmd+Space for custom launcher)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 '<dict><key>enabled</key><false/></dict>'

# 

# Restart affected applications
for app in Dock Finder SystemUIServer
    killall $app 2>/dev/null
end

echo 'done (some changes require logout/restart)'
