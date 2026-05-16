function v --description "Open the configured editor"
    if set -q EDITOR
        set -l editor_cmd (string split ' ' $EDITOR | string match -rv '^$')

        if test (count $editor_cmd) -gt 0; and type -q -- $editor_cmd[1]
            command $editor_cmd[1] $editor_cmd[2..-1] $argv
            return $status
        end
    end

    for editor in nvim vim vi
        if type -q -- $editor
            command $editor $argv
            return $status
        end
    end

    echo "v: no editor found" >&2
    return 127
end
