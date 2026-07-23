function tamagotchi_state
    set -l cache_file "$XDG_RUNTIME_DIR/tamagotchi_mood"

    if not test -f "$cache_file"
        # Daemon hasn't started yet - compute once directly
        tamagotchi_mood | string split -m 1 "::"
        return
    end

    string split -m 1 "::" <"$cache_file"
end
