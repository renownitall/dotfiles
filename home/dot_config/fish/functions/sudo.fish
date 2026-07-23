function sudo
    command sudo $argv
    set -l sudo_status $status

    if test $sudo_status -ne 0
        echo '(´-ω-`)  skill issue tbh' >&2
    end

    return $sudo_status
end
