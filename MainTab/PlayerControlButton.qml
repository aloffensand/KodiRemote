import QtQuick 2.2

// Supports the same features as a ControlButton: Two shortcut and a tooltip
// generated from a description and the shortcut(s).
// However, it is only enabled when a player is chosen, the shortcuts need
// shortcutFocus in addition (as usual).
ControlButton {
    enabled: playerControls.playing
}
