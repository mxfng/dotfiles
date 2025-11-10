# dotfiles

My preferred configurations and software for macOS systems.

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

To install nvim plugins:

```bash
./sync -i
./sync --install
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

## Thanks

I forked [Mitchell Simon's](https://github.com/mitchell/dotfiles) excellent dotfiles for some time and eventually used them as a guiding inspiration for my own. A decent amount of the code here stems from or was inspired by Mitchell's original project. Thanks Mitchell!
