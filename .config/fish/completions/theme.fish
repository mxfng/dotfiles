complete -c theme -f -a '(string match -rv "^#" <~/.config/theme/themes.tsv | string split -f1 \t)'
