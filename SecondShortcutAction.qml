import QtQuick 2.2
import QtQuick.Controls 1.2

Action {
    property var mainAction: ''
    shortcut: mainAction.shortcut1
    enabled: mainAction.enabled
    onTriggered: mainAction.trigger()
}
