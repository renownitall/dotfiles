function md5cp --description "Copy MD5 hash of a file to clipboard"
    if test (count $argv) -ne 1
        echo "Usage: md5cp <file>" >&2
        return 1
    end

    if not test -f $argv[1]
        echo "Error: File '$argv[1]' not found." >&2
        return 1
    end

    set hash (md5sum $argv[1] | cut -d ' ' -f1)

    # Determine the session type and copy to clipboard accordingly
    if test "$XDG_SESSION_TYPE" = wayland; or test -n "$WAYLAND_DISPLAY"
        if not command -q wl-copy
            echo "Error: 'wl-copy' not found. Install wl-clipboard." >&2
            return 1
        end
        echo -n $hash | wl-copy
    else if test "$XDG_SESSION_TYPE" = x11; or test -n "$DISPLAY"
        if command -q xclip
            echo -n $hash | xclip -selection clipboard
        else if command -q xsel
            echo -n $hash | xsel --clipboard --input
        else
            echo "Error: No clipboard tool found. Install xclip or xsel." >&2
            return 1
        end
    else
        echo "Error: No supported display server detected (Wayland or X11)." >&2
        return 1
    end

    echo "md5cp: MD5 hash copied to clipboard: $hash"
end
