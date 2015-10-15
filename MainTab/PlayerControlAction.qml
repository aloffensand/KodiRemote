import QtQuick 2.2

// Supports the same features as a ControlAction (second shortcut and a tooltip
// generated from a description and the shortcut(s)).
// However, it is only enabled when mainTab is active AND a player is chosen.
ControlAction {
    enabled: mainTab.focus && playerControls.playing
}
