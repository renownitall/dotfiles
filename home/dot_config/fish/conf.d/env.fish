set -q BROWSER; or set -gx BROWSER helium-browser
set -q FILEMANAGER; or set -gx FILEMANAGER thunar
set -q PASSWORD_MANAGER; or set -gx PASSWORD_MANAGER keepassxc
set -q EDITOR; or set -gx EDITOR nvim

# Qt Wayland theming
set -q QT_QPA_PLATFORM; or set -gx QT_QPA_PLATFORM wayland
set -q QT_QPA_PLATFORMTHEME; or set -gx QT_QPA_PLATFORMTHEME qt5ct

set -g fish_key_bindings fish_vi_key_bindings
fish_add_path "$HOME/.local/share/nvim/mason/bin"

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
