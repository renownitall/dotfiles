# Builtin Functions
set -l cachyos_fish_config /usr/share/cachyos-fish-config/cachyos-config.fish
if test -f $cachyos_fish_config
    source $cachyos_fish_config

    # CachyOS overrides the standard `history` function; this restores it
    if functions --query history
        functions --erase history
    end
end

function fish_greeting
    if not functions --query tamagotchi_state
        echo "(・_・) hello"
        return
    end

    set -l mood_data (tamagotchi_state 2>/dev/null)
    if test (count $mood_data) -lt 2
        echo "(・_・) hello"
        return
    end

    set -l mood $mood_data[1]
    set -l kaomoji $mood_data[2]

    if test -z "$kaomoji"
        set kaomoji "(・_・)"
    end

    if not functions --query tamagotchi_message
        echo "$kaomoji hello"
        return
    end

    set -l msg (tamagotchi_message greeting $mood)
    echo "$kaomoji $msg"
end

# Tools
if type -q fnm
    fnm env --use-on-cd | source
end

if type -q zoxide
    zoxide init fish | source
end
