# The look and keys of the fzf pickers (window-switcher, project-picker).
# Source this file. Then give "${picker_opts[@]}" and the output of
# picker_esc to fzf.
#
# Keys:
#   j, k       move down, move up
#   l, Enter   choose the selected row
#   g, G       go to the first row, go to the last row
#   q, Esc     close
#   /          open the search
#   Esc        in the search: clear the search and go back to j and k

picker_nav='j,k,l,g,G,q,/'

# The search box starts hidden, so j and k move the cursor.
picker_opts=(
  --ansi --reverse --no-input --with-shell 'bash -c'
  # The prompt is the Nerd Font nf-fa-search icon.
  --prompt "$(printf '')  " --pointer '▌' --gutter ' ' --ellipsis '…'
  --info inline-right --no-scrollbar --highlight-line
  --color 'bg+:0,gutter:-1,pointer:4,prompt:4,hl:4,hl+:4,border:4'
  --preview-window 'right,60%,border-left,noinfo'
  --bind 'j:down,k:up,l:accept,g:first,G:last,q:abort'
  --bind "/:show-input+unbind($picker_nav)"
)

# Print the Esc binding. Esc first runs the fzf actions in $1. These
# actions must clear the search. Then, in the search, Esc hides the search
# box and gives back the j and k keys. Outside the search, Esc closes the
# picker.
# Do not send $1 through transform: fzf ignores a clear-query that comes
# from transform.
picker_esc() {
  printf 'esc:%s+transform:[ "$FZF_INPUT_STATE" = hidden ] && echo abort || echo %q' \
    "$1" "hide-input+rebind($picker_nav)"
}
