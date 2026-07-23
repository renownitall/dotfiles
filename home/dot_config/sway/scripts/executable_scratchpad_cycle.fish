#!/usr/bin/env fish

# Cycle scratchpad windows, completely ignoring the dropdown terminal.
set -l tree (swaymsg -t get_tree)

# Get the ID of the currently focused window
set -l focused_id (echo $tree | jq -r '
  [.. | select(.focused? == true)] | first | .id
')

# Get all HIDDEN scratchpad windows (excluding drop_term)
# (Windows that are currently inside the __i3_scratch workspace)
set -l hidden_ids (echo $tree | jq -r '
  [ .nodes[].nodes[]
    | select(.name == "__i3_scratch")
    | .floating_nodes[]
    | select((.marks // [] | index("drop_term")) | not)
    | .id
  ] | .[]
')

# Get ALL scratchpad windows anywhere in Sway (excluding drop_term)
# (Any window where the scratchpad_state is not "none")
set -l all_scratch_ids (echo $tree | jq -r '
  [ ..
    | select(.scratchpad_state? != null and .scratchpad_state? != "none")
    | select((.marks // [] | index("drop_term")) | not)
    | .id
  ] | .[]
')

# Find which scratchpad windows are currently VISIBLE
# (By taking all scratchpad windows and subtracting the hidden ones)
set -l visible_ids
for id in $all_scratch_ids
    if not contains $id $hidden_ids
        set -a visible_ids $id
    end
end

# Case A: The focused window is a visible scratchpad window.
# Action: Hide it. (It will be placed at the back of the scratchpad queue).
if contains $focused_id $visible_ids
    swaymsg "[con_id=$focused_id] move scratchpad"
    exit 0
end

# Case B: A scratchpad window is visible, but NOT focused.
# (e.g., Left open on Workspace 1 and switched to Workspace 2).
# Action: Pull it to the current workspace and focus it.
if test (count $visible_ids) -gt 0
    swaymsg "[con_id=$visible_ids[1]] scratchpad show"
    exit 0
end

# Case C: No scratchpad windows are visible anywhere.
# Action: Show the first hidden one in the queue.
if test (count $hidden_ids) -gt 0
    swaymsg "[con_id=$hidden_ids[1]] scratchpad show"
    exit 0
end
