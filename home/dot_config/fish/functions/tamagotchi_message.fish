function tamagotchi_message
    set -l context "$argv[1]"
    set -l mood "$argv[2]"
    set -l file "$HOME/.config/tamagotchi/messages.txt"

    if not test -f "$file"
        echo hello
        return
    end

    set -l matches (awk -F'[|]' -v c="$context" -v m="$mood" '!/^#/ && $1 == c && $2 == m {print $3}' "$file")

    if test (count $matches) -eq 0
        set matches (awk -F'[|]' -v c="$context" '!/^#/ && $1 == c && $2 == "*" {print $3}' "$file")
    end

    if test (count $matches) -eq 0
        echo hello
        return
    end

    echo $matches[(random 1 (count $matches))]
end
