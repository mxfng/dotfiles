function configure_nnn --description "Configure nnn file manager"
    set -Ux NNN_PLUG 'f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'
    set -Ux NNN_FCOLORS 0000E6310000000000000000
    set -Ux NNN_FIFO "/tmp/nnn.fifo"

    alias nnn "nnn -e"

    set -l plugin_dir $XDG_CONFIG_HOME/nnn/plugins
    if test -z $XDG_CONFIG_HOME
        set plugin_dir $HOME/.config/nnn/plugins
    end

    if not test -d "$plugin_dir"
        echo "Installing nnn plugins to $plugin_dir"
        curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
    end
end
