#!/usr/bin/env fish

set -l app_id foot_drop

set -l runtime_dir "$XDG_RUNTIME_DIR"
if test -z "$runtime_dir"
    set runtime_dir /tmp
end

set -l lockdir "$runtime_dir/toggle_drop_term.lock"
set -l lockfile "$lockdir/pid"

set -l have_lock false

if mkdir "$lockdir" 2>/dev/null
    echo $fish_pid >"$lockfile"
    set have_lock true
else
    set -l pid ""
    if test -f "$lockfile"
        set pid (string trim (cat "$lockfile"))
    end

    set -l stale false

    if test -z "$pid"
        set stale true
    else if not string match -qr '^[0-9]+$' -- "$pid"
        set stale true
    else if not kill -0 "$pid" 2>/dev/null
        set stale true
    else
        set -l now (date +%s)
        set -l mtime (stat -c %Y "$lockdir" 2>/dev/null)
        if test -z "$mtime"
            set mtime 0
        end

        if test (math "$now - $mtime") -gt 10
            set stale true
        end
    end

    if test "$stale" = true
        rm -rf "$lockdir"
        if mkdir "$lockdir" 2>/dev/null
            echo $fish_pid >"$lockfile"
            set have_lock true
        end
    end
end

if not test "$have_lock" = true
    exit 0
end

swaymsg "[con_mark=drop_term] scratchpad show" >/dev/null 2>&1
set -l toggle_status $status

if test $toggle_status -eq 0
    rm -rf "$lockdir"
    exit 0
end

swaymsg exec "foot --app-id=$app_id"
rm -rf "$lockdir"
