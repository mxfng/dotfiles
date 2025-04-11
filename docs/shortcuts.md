# Workflow Shortcuts

## Quick Launch
| Shortcut | Action |
|----------|--------|
| ⌥ + space | Open terminal (WezTerm) |
| shift + ⌥ + return | Open web browser (Arc) |

# Window Management Shortcuts

## Focus Windows
| Shortcut | Action |
|----------|--------|
| ⌥ + h/j/k/l | Focus window in direction (vim keys) |

## Move Windows
| Shortcut | Action |
|----------|--------|
| shift + ⌥ + h/j/k/l | Swap window positions |
| shift + ⌘ + h/j/k/l | Move window in direction |

## Spaces
| Shortcut | Action |
|----------|--------|
| ⌘ + ⌥ + 1-9 | Focus space |
| shift + ⌘ + 1-9 | Move window to space |

## Window States
| Shortcut | Action |
|----------|--------|
| ⌥ + t | Toggle float |
| ⌥ + p | Picture-in-picture |
| ⌥ + f | Fullscreen |
| ⌥ + d | Parent zoom |

## Layout
| Shortcut | Action |
|----------|--------|
| ⌥ + e | Toggle split |
| ⌥ + r | Rotate tree |

> Note: all commands for yabai at ~/.skhdrc

# Tmux Shortcuts

> Note: prefix is ctrl+a

## Sessions
| Command | Action |
|---------|--------|
| tmux new -s name | Create new named session |
| tmux ls | List sessions |
| tmux attach -t name | Attach to named session |
| prefix + d | Detach from session |

## Windows (Tabs)
| Shortcut | Action |
|----------|--------|
| prefix + c | Create new window |
| prefix + n | Next window |
| prefix + p | Previous window |
| prefix + w | List windows |
| prefix + , | Rename window |
| prefix + & | Kill window |

## Panes (Splits)
| Shortcut | Action |
|----------|--------|
| prefix + " | Split vertically |
| prefix + % | Split horizontally |
| prefix + x | Kill pane |
| prefix + arrows | Navigate between panes |
| prefix + z | Toggle pane zoom |

## Misc
| Shortcut | Action |
|----------|--------|
| prefix + t | Show the time |

# NNN File Manager Shortcuts

## Navigation
| Shortcut | Action |
|----------|--------|
| ^E | End |
| ^J | Toggle auto-advance on open |
| B | Bookmark |
| , | Mark location in-memory |
| 1-4 | Switch context |
| (Sh)Tab | Cycle/new context |
| ^Q | Quit |
| ^y | Next young |
| ^G | Quit and cd to directory |
| Q | Pick selection and quit |
| q | Quit context |

## Filter & Prompt
| Shortcut | Action |
|----------|--------|
| / | Filter |
| ^N | Toggle type-to-nav |
| Esc | Exit prompt |
| ^L | Toggle last filter |
| . | Toggle hidden files |
| Alt+Esc | Unfilter, quit context |

## Files
| Shortcut | Action |
|----------|--------|
| o/^O | Open with... |
| n | Create new/link |
| f/^F | File details |
| d | Detail mode toggle |
| ^R | Rename/duplicate |
| r | Batch rename |
| z | Archive |
| e | Edit file |
| * | Toggle executable |
| > | Export list |
| Space/+ | (Un)select |
| m-m | Select range/clear |
| a | Select all |
| A | Invert selection |
| p/^P | Copy here |
| w/^W | Copy/move selection as |
| v/^V | Move here |
| E | Edit selection list |
| x/^X | Delete or trash |
| S | Listed selection size |
| X | Delete (rm -rf) |
| Esc | Send to FIFO |

## Misc
| Shortcut | Action |
|----------|--------|
| Alt+; | Select plugin |
| = | Launch app |
| !/^] | Shell |
| ] | Command prompt |
| c | Connect remote |
| u | Unmount remote/archive |
| t/^T | Sort toggles |
| s | Manage session |
| T | Set time type |
| 0 | Lock |
| ^L | Redraw |
| ? | Help, configuration |

