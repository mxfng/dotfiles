# max's dotfiles

My preferred configurations and software for macOS systems.

**Included:**

- fish shell
- git
- Wez's terminal
- yabaiwm (macOS)
- skhd (macOS)

**todo:**
- cursor
- tmux
- neovim (someday)

## Scripts


### `sync`


#### Dependencies

- brew ([install guide](https://docs.brew.sh/Installation))
- fish


#### Usage

To get new configurations:

```bash
./sync -d
./sync --desktop
```

To set up git:

```bash
./sync -g
./sync --git
```

To get new configurations for terminal only:

```bash
./sync
```

To run sync script using curl:

```bash
curl https://raw.githubusercontent.com/mxfng/dotfiles/master/sync | fish
```

### `provision`


#### Dependencies

- brew
- fish


#### Usage

Clone this repo and run the following for a fresh environment:

```bash
./provision terminal | fish
```

To install desktop software:

```bash
./provision desktop | fish
```

## Usage

### Terminal

- Open terminal: `⌥+space`
- Open web browser: `shift+⌥+space` 

### File Management

- File navigation: `nnn` for interactive file browser
- Fuzzy finding:
  ```bash
  fzf                  # Find files
  git log | fzf        # Search git history  
  history | fzf        # Search command history
  ```
- Smart directory jumping: Use `z` instead of `cd`
- File searching with Silver Searcher:
  ```bash
  ag "pattern"         # Search file contents
  ag -l "pattern"     # List matching files
  ag -g "pattern"     # Search filenames
  ```
- File viewing: Use `bat` instead of `cat` for syntax highlighting

### Remote Access

Use `mosh` for resilient SSH connections:
- Maintains connection through network changes
- Automatically reconnects
- Provides instant feedback

### Desktop Apps

- Install desktop apps: `./provisions -d`
- Configure Raycast (Spotlight replacement): Set hotkey to `cmd+space`

### Window Management

Window control with keyboard shortcuts:

Navigation:
- Focus windows: `⌥ + h/j/k/l` (vim-style)
- Swap windows: `shift + ⌥ + h/j/k/l`
- Move windows: `shift + ⌘ + h/j/k/l`

Spaces:
- Focus space: `⌘ + ⌥ + [1-9]`
- Move to space: `shift + ⌘ + [1-9]`

Window modes:
- Float: `⌥ + t`
- Picture-in-picture: `⌥ + p`
- Fullscreen: `⌥ + f`
- Parent zoom: `⌥ + d`

Layout:
- Toggle split: `⌥ + e`
- Rotate tree: `⌥ + r`

View all shortcuts: Type `keys` or see [keyboard shortcuts](./docs/shortcuts.md)

### Documentation

- View markdown: Use `glow`
- Get inspired: Type `quote`
