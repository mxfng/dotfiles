function fish_greeting
    set_color $fish_color_autosuggestion
    quote
    echo
    set uname (uname -nor)
    command -s uptime >/dev/null
    and if test (uname) = Linux
        and set uptime '; ' (uptime --pretty)
    else
        and set uptime '; ' (uptime)
    end
    echo -s $uname $uptime
    set_color normal
end
