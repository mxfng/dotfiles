function configure_fish
    set uname (uname)

    umask 077

    define_global_variables
    import_sources $uname
    define_aliases $uname
    ssh_agent_startup
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
end

configure_fish
