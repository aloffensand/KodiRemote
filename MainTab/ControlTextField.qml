import QtQuick 2.5
import QtQuick.Controls 1.2

// A Button with some preset values that generates shortcuts.
// The tooltip is generated from the description and the associated
// shortcut(s).

TextField {
    id: textField
    property string description: ''
    property string shortcut: ''
    property string shortcut1: ''
    placeholderText: {
        var str = description
        if (shortcut + shortcut1 != '') {
            str += ' ('
            if (shortcut != '' && shortcut1 != '') {
                str += shortcut + ', ' + shortcut1 + ')'
            } else {
                str += shortcut + shortcut1 + ')'
            }
        }
        return str
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Escape) {
            mainRec.returnFocus()
            event.accepted = true
        }
    }

    Shortcut {
        sequence: textField.shortcut
        onActivated: textField.focus = true
        enabled: mainRec.shortcutFocus
    }
    Shortcut {
        sequence: textField.shortcut1
        onActivated: textField.focus = true
        enabled: mainRec.shortcutFocus
    }
}
