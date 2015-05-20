import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

// FIXME: Use iconName when possible. How do I do that?
Button {
    iconName: ''
    iconSource: iconName == '' ? '' : 'icons/' + iconName + '.png'
    tooltip: ''
    activeFocusOnTab: false

    style: ButtonStyle {
        background: Image {
            source: control.iconSource
        }
        label: null
    }
}
