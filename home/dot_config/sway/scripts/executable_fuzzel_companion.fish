#!/usr/bin/env fish

set -l mood_data (tamagotchi_state 2>/dev/null)
set -l mood ""
set -l kaomoji "(・_・)"

if test (count $mood_data) -ge 2
    set mood $mood_data[1]
    set kaomoji $mood_data[2]
end

set -l msg (tamagotchi_message launcher $mood)

exec fuzzel --placeholder="$kaomoji $msg"
