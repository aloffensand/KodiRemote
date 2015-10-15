import QtQuick 2.2
import QtQuick.Controls 1.2

// Just an action with some preset values.
// It supports an additional shortcut shortcut1 when used with a
// SecondShortcutAction with mainAction set to this element's id.
// The tooltip is generated from the description and shortcut(s).
// It is only enabled when the mainTab has focus so that the shortcuts don't
// trigger it while in another tab.
Action {
    property string description: ''
    property string shortcut1: ''
    enabled: mainTab.focus
    tooltip: {
        var str = description
        if (shortcut + shortcut1 != '') {
            str += ' ('
            if (shortcut != '' && shortcut1 != '') {
                str += shortcut + ', ' + shortcut1 + ')'
            } else {
                str += shortcut + shortcut1
            }
            str += ')'
        }
        return str
    }
    iconSource: 'icons/' + iconName + '.png'
}
