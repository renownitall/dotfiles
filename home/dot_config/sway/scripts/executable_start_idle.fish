#!/usr/bin/env fish

swayidle -w \
    timeout 50 'notify-send -u low -t 10000 -p "(っ˘ω˘ς)  u still there?" "gonna lock up in 10s if not" > "$XDG_RUNTIME_DIR/idle_warning_id"' \
    resume '$HOME/.config/sway/scripts/idle_resume.fish' \
    timeout 60 '$HOME/.config/sway/scripts/sleepy_lock.fish' \
    timeout 120 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' \
    timeout 180 'systemctl suspend' \
    before-sleep '$HOME/.config/sway/scripts/sleepy_lock.fish --now'
