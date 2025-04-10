# dotfiles

This repo contains my preferred configurations for:

- fish shell
- code | cursor
- git
- yabaiwm (macOS)
- skhd (macOS)
- wezterm

# Scripts

## `provision`

Provision various environments and tools on macOS. Will add Linux someday when I eventually need it.

### Dependencies

- fish
- xcode (maybe?) todo: validate this

## `sync`

Syncs all configuration files found in this repository to your home folder.

### Dependencies

- fish
- git
- rsync
- curl

To run this script with curl:
```
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish
```

# Keyboard Shortcuts

## Terminal (Fish Shell)
- `,r` - search command history
- `,c` - fuzzy find and cd into directory
- `Ctrl+T` - fuzzy find files and directories
- `Alt+C` - fuzzy find and cd into directory

## Window Management (skhd + yabai)
### App Shortcuts
- `⌥ + Space` - open wezterm
- `⇧ + ⌘ + Return` - open browser

### Window Management
- `⌃ + ⌘ + Left` - move window to left half
- `⌃ + ⌘ + Right` - move window to right half
- `⌃ + ⌘ + Up` - full screen
- `⌃ + ⌘ + Down` - center window

### Quarter Screen
- `⌃ + ⇧ + ⌘ + Left` - top left quarter
- `⌃ + ⇧ + ⌘ + Right` - top right quarter
- `⌃ + ⇧ + ⌘ + Up` - bottom left quarter
- `⌃ + ⇧ + ⌘ + Down` - bottom right quarter

### Navigation
- `⌥ + Left` - focus left window
- `⌥ + Right` - focus right window
- `⌥ + Up` - focus up window
- `⌥ + Down` - focus down window

### Space Control
- `⌘ + 1/2/3` - focus desktop 1/2/3
- `⇧ + ⌘ + 1/2/3` - move window to desktop 1/2/3

### Window Toggles
- `⌥ + f` - toggle fullscreen
- `⌥ + t` - toggle float/tiling

## Terminal (WezTerm)
- `⌃ + ⇧ + Enter` - split vertically
- `⌃ + ⇧ + "` - split horizontally
- `⌃ + ⇧ + h/j/k/l` - navigate splits
- `⌃ + ⇧ + ⌘ + h/j/k/l` - resize splits