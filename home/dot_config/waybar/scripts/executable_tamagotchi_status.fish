#!/usr/bin/env fish

set -l mood ""
set -l kaomoji "(・_・)"

if functions --query tamagotchi_state
    set -l mood_data (tamagotchi_state 2>/dev/null)
    if test (count $mood_data) -ge 2
        set mood $mood_data[1]
        set kaomoji $mood_data[2]
    end
end

if test -z "$kaomoji"
    set kaomoji "(・_・)"
end

set -l tooltip (tamagotchi_message tooltip $mood)

printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$kaomoji" "$tooltip" "$mood"
