#!/usr/bin/env fish

set -l action $argv[1]
set -l state_file "$XDG_RUNTIME_DIR/swaynag_action"

if pgrep -x swaynag >/dev/null
    set -l current_action ""
    if test -f "$state_file"
        set current_action (cat "$state_file")
    end

    pkill -x swaynag

    if test "$current_action" = "$action"
        rm -f "$state_file"
        exit 0
    end
end

set -l cmd
set -l msg
set -l confirm_msg
set -l cancel_msg

switch $action
    case poweroff
        set cmd "systemctl poweroff"
        set msg "(╥﹏╥)  u gonna shut down?"
        set confirm_msg 'yeah bye'
        set cancel_msg 'nah stay'
    case reboot
        set cmd "systemctl reboot"
        set msg "(>.<)  gonna restart rq"
        set confirm_msg cya
        set cancel_msg 'nah stay'
    case suspend
        set cmd "systemctl suspend"
        set msg "(∪｡∪)  naptime? say less"
        set confirm_msg 'sleep well'
        set cancel_msg 'nah stay up'
    case logout
        set cmd "systemctl --user stop sway-session.target; swaymsg exit"k
        set msg "(⊙_⊙; )  wait ur leaving??"
        set confirm_msg 'yeah bye'
        set cancel_msg 'nah stay'
    case '*'
        exit 1
end

echo "$action" >"$state_file"

swaynag -t warning \
    -m "$msg" \
    -B "$confirm_msg" "$cmd" \
    -s x \
    -Z "$cancel_msg" true

# Only clean up if we're still the active action
if test -f "$state_file"; and test (cat "$state_file") = "$action"
    rm -f "$state_file"
end
