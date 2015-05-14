import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    id: generalControls
    color: 'transparent'
    height: childrenRect.height
    width: childrenRect.width

    Keys.onPressed: {
        if (event.key == Qt.Key_T) {
            textBox.focus = true
            event.accepted = true
        }
    }

    Action {
        id: settingsAction
        shortcut: shortcut_settings
        onTriggered: {
            log('debug', 'Settings')
        }
    }

    Action {
        id: upAction
        //text: 'Up'
        tooltip: 'Up (Up Arrow)'
        iconName: 'go-up'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_up
        onTriggered: {
            log('debug', 'Moving up')
            sendCommand('"input.up"', '{}')
        }
    }
    Action {
        id: downAction
        //text: "Down"
        tooltip: 'Down (Down Arrow)'
        iconName: 'go-down'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_down
        onTriggered: {
            log('debug', 'Moving down')
            sendCommand('"input.down"', '{}')
        }
    }
    Action {
        id: leftAction
        //text: 'Left'
        tooltip: 'Left (Left Arrow)'
        iconName: 'go-previous'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_left
        onTriggered: {
            log('debug', 'Moving left')
            sendCommand('"input.left"', '{}')
        }
    }
     Action {
        id: rightAction
        //text: 'Right'
        tooltip: 'Right (Right Arrow)'
        iconName: 'go-next'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_right
        onTriggered: {
            log('debug', 'Moving right')
            sendCommand('"input.right"', '{}')
        }
    }
    Action {
        id: backAction
        //text: 'Back'
        tooltip: 'Back (Backspace)'
        iconName: 'edit-undo'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_back
        onTriggered: {
            log('debug', 'Moving back')
            sendCommand('"Input.Back"', '{}')
        }
    }
    Action {
        id: homeAction
        //text: '&Home'
        tooltip: 'Home (H)'
        iconName: 'go-home'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_home
        onTriggered: {
            log('debug', 'Going Home')
            sendCommand('"Input.Home"', '{}')
        }
    }
    Action {
        id: selectAction
        //text: 'Select'
        tooltip: 'Select (Return)'
        iconName: 'key-enter'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_select
        onTriggered: {
            log('debug', 'Selecting item')
            sendCommand('"Input.Select"', '{}')
        }
    }
    Action {
        id: contextAction
        //text: 'Context'
        tooltip: 'Context Menu (Context menu)'
        iconName: 'open-menu-symbolic.symbolic'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_context
        onTriggered: {
            log('debug', 'Opening context menu')
            sendCommand('"Input.ContextMenu"', '{}')
        }
    }
    Action {
        id: infoAction
        //text: '&Info'
        tooltip: 'Information (i)'
        iconName: 'help-about'
        iconSource: 'icons/' + iconName + '.png'
        shortcut: shortcut_info
        onTriggered: {
            log('debug', 'Showing informations')
            sendCommand('"Input.Info"', '{}')
        }
    }

    Action {
        id: sendTextAction
        text: 'Send'
        tooltip: 'Send text (Enter while in input field)'
        onTriggered: {
            log('debug', 'Sending text ' + textBox.text)
            sendCommand('"Input.SendText"', '{"text": "' + textBox.text + '"}')
            sendCommand('"Input.endText"', '{"text": "' + textBox.text + '"}')
            generalControls.focus = true
        }
    }

    Grid {
        id: controlGrid
        columns: 3
        Button { action: backAction }
        Button { action: upAction }
        Button { action: infoAction }
        Button { action: leftAction }
        Button { action: selectAction }
        Button { action: rightAction }
        Button { action: homeAction }
        Button { action: downAction }
        Button { action: contextAction }
    }
    Row {
        anchors.left: controlGrid.right
        anchors.leftMargin: 5
        anchors.bottom: controlGrid.bottom
        TextField {
            id: textBox
            placeholderText: 'Send text (t)'
            onAccepted: sendTextAction()
            Keys.onPressed: {
                if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                    sendTextAction.onTriggered()
                    event.accepted = true
                } else if (event.key == Qt.Key_Escape) {
                    generalControls.focus = true
                    event.accepted = true
                }
            }
        }
        Button {
            action: sendTextAction
        }
    }
}
