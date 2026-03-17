function confirm -a prompt default
    read -P "$prompt " answer
    set -l answer (string lower $answer)

    if test -z "$answer"
        test "$default" = Y
    else
        string match -q -r '^y' $answer
    end
end
