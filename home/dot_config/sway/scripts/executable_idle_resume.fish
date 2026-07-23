#!/usr/bin/env fish

if not set -q DBUS_SESSION_BUS_ADDRESS
    set -x DBUS_SESSION_BUS_ADDRESS "unix:path=$XDG_RUNTIME_DIR/bus"
end

# Dismiss only the idle warning notification by its stored ID.
# Other notifications that arrived in the meantime are untouched.
set -l id_file "$XDG_RUNTIME_DIR/idle_warning_id"
if test -f $id_file
    set -l nid (string trim (cat $id_file))
    if test -n "$nid"
        makoctl dismiss -n $nid 2>/dev/null
    end
    rm -f $id_file
end
