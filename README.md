# max's dotfiles

My preferred configurations and software for macOS systems.

Includes:
- fish shell
- tmux
- git
- Wez's terminal
- yabaiwm (macOS)
- skhd (macOS)


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

## `provision`


#### Dependencies

- brew
- fish


#### Usage

Clone this repo and run the following for a fresh environment:

```bash
./provision terminal | fish
```

To install desktop configs only:

```bash
./provision desktop | fish
```
