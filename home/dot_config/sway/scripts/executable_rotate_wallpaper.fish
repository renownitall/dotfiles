#!/usr/bin/env fish

set -l wallpaper_dir ~/Pictures/Wallpapers
set -l fallback /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png
set -l queue_file ~/.cache/wallpaper_queue
set -l transition_type fade
set -l transition_duration 1.5
set -l transition_fps 60

set -l retries 0
while not awww query >/dev/null 2>&1
    if test $retries -ge 20
        exit 1
    end
    sleep 0.1
    set retries (math $retries + 1)
end

mkdir -p (dirname "$queue_file")

# Repopulate queue if empty or missing.
# The queue is NUL-delimited to support filenames containing newlines.
if not test -s "$queue_file"
    if test -d "$wallpaper_dir"
        find "$wallpaper_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 | shuf -z >"$queue_file"
    end
end

if not test -s "$queue_file"
    awww img "$fallback" --transition-type $transition_type --transition-duration $transition_duration --transition-fps $transition_fps
    exit 0
end

set -l chosen ""
set -l tmp_queue (mktemp "$queue_file.XXXXXX")

while read -l -z line
    if test -r "$line"
        if test -z "$chosen"
            set chosen "$line"
        else
            printf '%s\0' "$line" >>"$tmp_queue"
        end
    end
end <"$queue_file"

mv "$tmp_queue" "$queue_file"

if test -z "$chosen"
    set chosen $fallback
    rm -f "$queue_file"
end

awww img "$chosen" --transition-type $transition_type --transition-duration $transition_duration --transition-fps $transition_fps
