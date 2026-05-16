function fastfetch --description "Fastfetch wrapper for custom logo and message"
    set -l config_dir ~/.config/fastfetch
    set -l ascii_file $config_dir/ascii.txt
    set -l messages_file $config_dir/messages.txt
    set -l box_width 34

    if not test -f $ascii_file
        command fastfetch $argv
        return $status
    end

    if not test -f $messages_file
        command fastfetch --logo $ascii_file $argv
        return $status
    end

    set -l messages
    set -l current_message

    while read -l line
        if test -z "$(string trim -- $line)"
            if set -q current_message[1]
                set -a messages (printf '%s\n' $current_message | string collect)
                set -e current_message
            end
        else
            set -a current_message $line
        end
    end <$messages_file

    if set -q current_message[1]
        set -a messages (printf '%s\n' $current_message | string collect)
    end

    if test (count $messages) -eq 0
        command fastfetch --logo $ascii_file $argv
        return $status
    end

    set -l chosen_message $messages[(random 1 (count $messages))]
    set -l aligned_message

    for line in (string split \n -- $chosen_message)
        set -l line_length (string length -- $line)
        set -l padding (math "max(0, $box_width - $line_length)")
        set -a aligned_message (string repeat -n $padding ' ')$line
    end

    set -l temp_logo (mktemp)
    or begin
        echo "fastfetch: failed to create a temporary file" >&2
        return 1
    end

    command cat -- $ascii_file >$temp_logo
    printf '%s\n' $aligned_message >>$temp_logo

    command fastfetch --logo $temp_logo $argv
    set -l exit_status $status
    command rm -f -- $temp_logo
    return $exit_status
end
