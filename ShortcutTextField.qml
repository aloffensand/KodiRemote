import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: childrenRect.width
    height: childrenRect.height
    color: "transparent"
    property bool valid: true
    property bool unique: true
    property int arrayIndex: 0
    property string target: ''
    property string shortcut: frame[target]
    property string oldShortcut: frame[target]

    Timer {
        id: updateTimer
        interval: 3000
        onTriggered: {
            if (textField.focus) {
                shortcutSettings.changeShortcut(
                    textField.text, oldShortcut, arrayIndex
                )
            }
        }
    }

    TextField {
        id: textField
        text: parent.shortcut
        onEditingFinished: {
            shortcutSettings.changeShortcut(text, oldShortcut, arrayIndex)
        }
        onTextChanged: {
            if (focus) {
                updateTimer.restart()
            }
        }
    }

    Icon {
        anchors.left: textField.right
        anchors.leftMargin: 3
        iconName: (!valid) ? 'dialog-error' :
                  (!unique) ? 'dialog-warning' : 'empty'
        tooltip: (!valid) ? 'This is not a valid shortcut!' :
                 (!unique) ? 'You have already assigned this shortcut to another element.' :
                 ''
    }
}
