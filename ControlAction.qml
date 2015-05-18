import QtQuick 2.2
import QtQuick.Controls 1.2

Action {
    property string description: ''
    property string shortcut1: ''
    enabled: mainTab.activeFocus
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
