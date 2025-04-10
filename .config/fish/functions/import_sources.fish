function import_sources -a uname -d 'Loads any additional fish files needed at init.'
    test -e ~/.asdf/asdf.fish
    and source ~/.asdf/asdf.fish
    and mkdir -p ~/.config/fish/completions
    and ln -sf ~/.asdf/completions/asdf.fish ~/.config/fish/completions
end
