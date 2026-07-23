#!/usr/bin/env fish

# Dismiss the previous toggle notification if it's still showing
set -l id_file "$XDG_RUNTIME_DIR/caffeine_toggle_id"
if test -f "$id_file"
    set -l nid (string trim (cat "$id_file"))
    if test -n "$nid"
        makoctl dismiss -n "$nid" 2>/dev/null
    end
end

if systemctl --user is-active --quiet swayidle.service
    systemctl --user stop swayidle.service
    notify-send -u low -t 3000 -p "☕ caffeine mode on" "swayidle stopped. we're staying up indefinitely" >"$id_file"
else
    systemctl --user start swayidle.service
    notify-send -u low -t 3000 -p "💤 caffeine mode off" "swayidle restarted. normal idle rules apply" >"$id_file"
end
