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
./sync -d # --desktop
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

To install desktop software only:

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

   Try `fzf` - a fuzzy finder for:
   - Files: `fzf`
   - Git history: `git log | fzf`
   - Command history: `history | fzf`

5. #### Smart directory navigation?

   Use `zoxide` - it learns your habits:
   - `z <partial-name>` to jump to a directory
   - `zi` for interactive mode
   - `zq` to query without jumping

6. #### Better file searching?

   Try `ag` (The Silver Searcher):
   - `ag "pattern"` to search files
   - `ag -l "pattern"` to list matching files
   - `ag -g "pattern"` to search filenames

7. #### Need to read or display files?

   Use `bat` - a better `cat`:
   - Syntax highlighting
   - Git integration
   - Line numbers
   - Pager support

8. #### Working with YAML?

   Use `yq` for YAML processing:
   - `yq e '.key' file.yml` to extract values
   - `yq e -i '.key = "value"' file.yml` to edit
   - `yq e -P file.yml` to pretty print

9. #### Remote connections?

   Try `mosh` for better SSH:
   - Works on unreliable connections
   - Reconnects automatically
   - Local echo for better responsiveness

10. #### Want a better Spotlight app?

    Download and use Raycast with `./provisions -d` and re-configure the hotkey with `cmd+space`