status is-interactive; or return

set -l cachyos_default_config /usr/share/cachyos-fish-config/cachyos-config.fish
if test -f $cachyos_default_config
    source $cachyos_default_config
end

# CachyOS overrides the default Fish wrapper for the 'history' command
if functions -q history
    functions -e history
end

set -l fish_history_wrapper /usr/share/fish/functions/history.fish
if test -f $fish_history_wrapper
    source $fish_history_wrapper
end
