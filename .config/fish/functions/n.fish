function n --description "A smart wrapper around `nnn` with auto-cd behavior"
    nnn -a -e $argv
    if test -f $NNN_TMPFILE
        cd (bat $NNN_TMPFILE)
        rm $NNN_TMPFILE
    end
end
