#!/bin/sh
# Sway session autostart helper.
#
# This prepares the systemd user environment and starts session services.
# It intentionally does not try to mutate Sway's own environment; Sway
# inherits that from whatever launched it

if ! command -v systemctl >/dev/null 2>&1; then
  exit 0
fi

# Import useful variables from the Sway process, if present
systemctl --user import-environment \
  DISPLAY \
  WAYLAND_DISPLAY \
  XDG_SESSION_TYPE \
  XDG_CURRENT_DESKTOP \
  QT_QPA_PLATFORM \
  QT_QPA_PLATFORMTHEME \
  2>/dev/null || true

# Ensure sane session defaults for systemd user services
systemctl --user set-environment \
  XDG_CURRENT_DESKTOP=sway \
  QT_QPA_PLATFORM=wayland \
  QT_QPA_PLATFORMTHEME=qt5ct \
  2>/dev/null || true

# Start the standard graphical session target if it exists
systemctl --user start --no-block graphical-session.target 2>/dev/null || true

# Start the Sway-specific session target, which pulls in enabled services
systemctl --user start --no-block sway-session.target 2>/dev/null || true
