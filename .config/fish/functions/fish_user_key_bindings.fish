function fish_user_key_bindings
    fzf --fish | source
    bind --mode insert ,r fzf-history-widget
    bind --mode insert ,c fzf-cd-widget
end
