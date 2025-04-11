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

For new configurations:

```bash
./sync -d
./sync --desktop
```

To set up git:

```bash
./sync -g
./sync --git
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

## Tips

1. #### Need a terminal?

   Type `⌥+space`

2. #### Need a web browser?

   Type `shift+⌥+space`

3. #### Looking for files?

   Try running `nnn`

4. #### Need something more specific?

   Try `fzf` - quickly find:
   - Files with `fzf`
   - Git commits with `git log | fzf` 
   - Past commands with `history | fzf`

5. #### Smart directory navigation?

   Use `z` instead of `cd` to jump to frequent directories

6. #### Better file searching?

   Try `ag` (The Silver Searcher):
   - `ag "pattern"` to search files
   - `ag -l "pattern"` to list matching files
   - `ag -g "pattern"` to search filenames

7. #### Need to read or display files?

   Use `bat` instead of `cat` for syntax highlighting and git integration

8. #### Remote connections?

   Try `mosh` for reliable SSH:
   - Survives bad connections
   - Auto-reconnects
   - Instant feedback

9. #### Want a better Spotlight app?

    Download and use Raycast and other apps by calling `./provisions -d`; re-configure Raycast's hotkey with `cmd+space`

10. #### Moving windows around?

    Use these keyboard shortcuts for window management:
    - Focus: `⌥ + h/j/k/l` (vim keys)
    - Swap: `shift + ⌥ + h/j/k/l`
    - Move: `shift + ⌘ + h/j/k/l`
    - Spaces: `⌘ + ⌥ + 1-9` to focus, `shift + ⌘ + 1-9` to move window
    - Float: `⌥ + t` to toggle float, `⌥ + p` for picture-in-picture
    - Zoom: `⌥ + f` for fullscreen, `⌥ + d` for parent zoom
    - Layout: `⌥ + e` to toggle split, `⌥ + r` to rotate tree

11. #### Want to see all the keyboard shortcuts?

    Type `keybindings` in the terminal to view all configured shortcuts for `skhd`

12. #### Need a dose of inspiration?

    Type `quote` in the terminal to see one from my collection

<small>a gift to my future self. made with ❤️ by max fung</small>



