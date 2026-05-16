status is-interactive; or return

# Initialize Starship.
if type -q starship
    starship init fish | source
end

# zoxide replaces the built-in cd command.
if type -q zoxide
    zoxide init fish --cmd cd | source
end
