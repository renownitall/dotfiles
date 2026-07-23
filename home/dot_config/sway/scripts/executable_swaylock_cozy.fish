#!/usr/bin/env fish

set -l config_dir "$HOME/.config/swaylock"
set -l base_config "$config_dir/config"
set -l effects_config "$config_dir/config.effects"

set -l use_effects false

if pacman -Q swaylock-effects >/dev/null 2>&1
    set use_effects true
else if type -q swaylock; and swaylock --help 2>&1 | string match -qr effect-blur
    set use_effects true
end

if test "$use_effects" = true; and test -f "$effects_config"
    exec swaylock --config "$effects_config" $argv
else
    exec swaylock --config "$base_config" $argv
end
