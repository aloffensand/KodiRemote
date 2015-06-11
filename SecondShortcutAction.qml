import QtQuick 2.2
import QtQuick.Controls 1.2

// An action that adds another shortcut to an Action with a property shortcut1.
Action {
    property var mainAction: ''
    shortcut: mainAction.shortcut1
    enabled: mainAction.enabled
    onTriggered: mainAction.trigger()
}
