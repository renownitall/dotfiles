function nekofetch
    set -l config_file "$HOME/.config/fastfetch/nekofetch.jsonc"
    set -l ascii_file "$HOME/.config/fastfetch/neko_ascii.txt"
    set -l messages_file "$HOME/.config/fastfetch/neko_messages.txt"
    set -l logo_file (mktemp /tmp/neko_logo.XXXXXX)

    if test -z "$logo_file"
        return 1
    end

    function _nekofetch_cleanup_signal --inherit-variable logo_file --on-signal INT --on-signal TERM --on-signal HUP
        rm -f "$logo_file"
        functions --erase _nekofetch_cleanup_signal _nekofetch_cleanup_exit
        exit 1
    end

    function _nekofetch_cleanup_exit --inherit-variable logo_file --on-event fish_exit
        rm -f "$logo_file"
        functions --erase _nekofetch_cleanup_signal _nekofetch_cleanup_exit
    end

    if not test -f "$ascii_file"
        rm -f "$logo_file"
        functions --erase _nekofetch_cleanup_signal _nekofetch_cleanup_exit
        return 1
    end

    set -l messages
    set -l current
    if test -f "$messages_file"
        while read -l line
            if test -z "$line"
                if test (count $current) -gt 0
                    set -a messages (string join -- \n $current | string collect)
                    set current
                end
            else
                set -a current "$line"
            end
        end <"$messages_file"
        if test (count $current) -gt 0
            set -a messages (string join -- \n $current | string collect)
        end
    end

    set -l message ""
    if test (count $messages) -gt 0
        set message $messages[(random 1 (count $messages))]
    end

    set -l art_width 0
    while read -l line
        set -l len (string length -- "$line")
        if test $len -gt $art_width
            set art_width $len
        end
    end <"$ascii_file"

    cat "$ascii_file" >"$logo_file"
    echo >>"$logo_file"

    if test -n "$message"
        set -l centered_lines
        for line in (string split -- \n "$message")
            set -l len (string length -- "$line")
            set -l pad (math --scale=0 "($art_width - $len) / 2")
            if test $pad -lt 0
                set pad 0
            end
            set -a centered_lines (printf '%*s%s' "$pad" '' "$line")
        end
        set -l centered_message (string join -- \n $centered_lines | string collect)
        printf '%s\n' "$centered_message" >>"$logo_file"
    end

    fastfetch --config "$config_file" --logo-type file --logo "$logo_file"
    set -l fastfetch_status $status

    rm -f "$logo_file"
    functions --erase _nekofetch_cleanup_signal _nekofetch_cleanup_exit
    return $fastfetch_status
end
