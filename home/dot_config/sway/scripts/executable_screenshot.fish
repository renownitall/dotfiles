#!/usr/bin/env fish

set -l mode $argv[1]

if not contains -- "$mode" full region focused
    exit 1
end

set -l tmp (mktemp /tmp/screenshot.XXXXXX)
if test -z "$tmp"
    exit 1
end

set -l geometry ""
if test "$mode" = focused
    set geometry (
        swaymsg -t get_tree | jq -r '
            [.. | select(.focused? == true)]
            | first
            | .rect?
            | select(. != null)
            | "\(.x),\(.y) \(.width)x\(.height)"
        '
    )

    if test -z "$geometry"
        rm -f "$tmp"
        exit 1
    end
end

set -x SCREENSHOT_MODE "$mode"
set -x SCREENSHOT_TMP "$tmp"
set -x SCREENSHOT_GEOMETRY "$geometry"

set -l after_cmd '
if [ "$SCREENSHOT_MODE" = "region" ]; then
    geometry="$(slurp)"
    if [ -z "$geometry" ]; then
        pkill -x wayfreeze 2>/dev/null
        rm -f "$SCREENSHOT_TMP"
        exit 0
    fi
    grim -g "$geometry" "$SCREENSHOT_TMP"
elif [ "$SCREENSHOT_MODE" = "focused" ]; then
    if [ -z "$SCREENSHOT_GEOMETRY" ]; then
        pkill -x wayfreeze 2>/dev/null
        rm -f "$SCREENSHOT_TMP"
        exit 1
    fi
    grim -g "$SCREENSHOT_GEOMETRY" "$SCREENSHOT_TMP"
else
    grim "$SCREENSHOT_TMP"
fi

pkill -x wayfreeze 2>/dev/null

if [ -s "$SCREENSHOT_TMP" ]; then
    if command -v swappy >/dev/null 2>&1; then
        swappy -f - < "$SCREENSHOT_TMP"
    elif command -v wl-copy >/dev/null 2>&1; then
        wl-copy < "$SCREENSHOT_TMP"
    fi
fi

rm -f "$SCREENSHOT_TMP"
'

set -l direct_cmd '
if [ "$SCREENSHOT_MODE" = "region" ]; then
    geometry="$(slurp)"
    if [ -z "$geometry" ]; then
        rm -f "$SCREENSHOT_TMP"
        exit 0
    fi
    grim -g "$geometry" "$SCREENSHOT_TMP"
elif [ "$SCREENSHOT_MODE" = "focused" ]; then
    if [ -z "$SCREENSHOT_GEOMETRY" ]; then
        rm -f "$SCREENSHOT_TMP"
        exit 1
    fi
    grim -g "$SCREENSHOT_GEOMETRY" "$SCREENSHOT_TMP"
else
    grim "$SCREENSHOT_TMP"
fi

if [ -s "$SCREENSHOT_TMP" ]; then
    if command -v swappy >/dev/null 2>&1; then
        swappy -f - < "$SCREENSHOT_TMP"
    elif command -v wl-copy >/dev/null 2>&1; then
        wl-copy < "$SCREENSHOT_TMP"
    fi
fi

rm -f "$SCREENSHOT_TMP"
'

if type -q wayfreeze
    wayfreeze --after-freeze-cmd "$after_cmd"
else
    sh -c "$direct_cmd"
end
