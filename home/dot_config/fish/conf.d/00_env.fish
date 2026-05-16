if not set -q EDITOR
    if type -q nvim
        set -gx EDITOR nvim
    end
end

if not set -q XDG_CONFIG_HOME
    set -gx XDG_CONFIG_HOME "$HOME/.config"
end

if not set -q XDG_CACHE_HOME
    set -gx XDG_CACHE_HOME "$HOME/.cache"
end

if not set -q XDG_DATA_HOME
    set -gx XDG_DATA_HOME "$HOME/.local/share"
end

if not set -q XDG_STATE_HOME
    set -gx XDG_STATE_HOME "$HOME/.local/state"
end

for path in ~/.local/bin ~/.local/share/nvim/mason/bin
    test -d $path; and fish_add_path $path
end
