#!/usr/bin/env fish

set -l immediate 0
if test (count $argv) -gt 0; and test $argv[1] = --now
    set immediate 1
end

if test $immediate -eq 0
    set -l mood_data (tamagotchi_state 2>/dev/null)
    set -l mood ""
    set -l kaomoji "(・_・)"

    if test (count $mood_data) -ge 2
        set mood $mood_data[1]
        set kaomoji $mood_data[2]
    end

    set -l msg (tamagotchi_message lock $mood)

    notify-send -u low -t 2500 "$kaomoji $msg" "locking screen..."
    sleep 2.5
end

makoctl mode -a locked 2>/dev/null
$HOME/.config/sway/scripts/swaylock_cozy.fish

sh -c '
    while pgrep -x swaylock > /dev/null; do
        sleep 0.1
    done

    # Re-establish DBUS if needed, then fire the welcome back msg
    if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
    fi

    makoctl mode -r locked 2>/dev/null
    makoctl dismiss -a 2>/dev/null
    notify-send -u low -t 3000 "(-_-)  oh ur back" "that was quick. or was it. i lost track"
' & disown
