function md5cp
    set -l hash (md5sum "$argv[1]" | awk '{print $1}')
    echo -n "$hash" | wl-copy
    echo "$hash"
end
