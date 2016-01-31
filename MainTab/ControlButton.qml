import QtQuick 2.5
import QtQuick.Controls 1.2

// A Button with some preset values that generates shortcuts.
// The tooltip is generated from the description and the associated
// shortcut(s).

Button {
    id: button
    property string description: ''
    property string shortcut: ''
    property string shortcut1: ''
    iconSource: 'qrc:///icons/' + iconName + '.png'
    tooltip: {
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

    Shortcut {
        sequence: button.shortcut
        onActivated: button.clicked()
        enabled: button.enabled && mainRec.shortcutFocus
    }
    Shortcut {
        sequence: button.shortcut1
        onActivated: button.clicked()
        enabled: button.enabled && mainRec.shortcutFocus
    }
}
