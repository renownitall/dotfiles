#!/usr/bin/env fish

set -l lockfile "$XDG_RUNTIME_DIR/tamagotchi_daemon.lock"
if test -f $lockfile
    set -l pid (string trim (cat $lockfile))
    if test -n "$pid"; and string match -qr '^[0-9]+$' -- "$pid"; and kill -0 "$pid" 2>/dev/null
        exit 0
    end
end
echo $fish_pid >"$lockfile"

set -l cache_file "$XDG_RUNTIME_DIR/tamagotchi_mood"
set -l last_state ""

while true
    set -l mood_data (tamagotchi_mood | string split "::")
    set -l mood $mood_data[1]
    set -l kaomoji $mood_data[2]

    # Atomic write
    set -l tmp_file (mktemp "$cache_file.XXXXXX")
    echo "$mood::$kaomoji" >"$tmp_file"
    mv "$tmp_file" "$cache_file"

    # Signal Waybar to refresh
    pkill -RTMIN+8 waybar 2>/dev/null

    set -l nagging_states critical_battery high_load late_night

    if contains -- $mood $nagging_states
        if test "$mood" != "$last_state"
            set -l title (tamagotchi_message daemon_title $mood)
            set -l body (tamagotchi_message daemon_body $mood)
            set -l urgency normal

            switch $mood
                case critical_battery
                    set urgency critical
            end
            notify-send -u $urgency -t 5000 "$title" "$body"
            set last_state "$mood"
        end
    else
        set last_state ""
    end

    sleep 30
end
