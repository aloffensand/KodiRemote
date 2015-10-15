import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    id: generalControls
    color: 'transparent'
    height: childrenRect.height
    width: childrenRect.width

    ControlAction {
        id: enterTextAction
        shortcut: shortcut_enterText
        shortcut1: shortcut_enterText1
        onTriggered: textBox.focus = true
    }
    SecondShortcutAction { mainAction: enterTextAction }

    ControlAction {
        id: settingsAction
        shortcut: shortcut_settings
        shortcut1: shortcut_settings1
        onTriggered: {
            log('debug', 'Settings')
        }
    }
    SecondShortcutAction { mainAction: settingsAction }

    ControlAction {
        id: upAction
        description: 'Up'
        iconName: 'go-up'
        shortcut: shortcut_up
        shortcut1: shortcut_up1
        onTriggered: {
            log('debug', 'Moving up')
            sendCommand('"input.up"', '{}')
        }
    }
    SecondShortcutAction { mainAction: upAction }
    ControlAction {
        id: downAction
        description: "Down"
        iconName: 'go-down'
        shortcut: shortcut_down
        shortcut1: shortcut_down1
        onTriggered: {
            log('debug', 'Moving down')
            sendCommand('"input.down"', '{}')
        }
    }
    SecondShortcutAction { mainAction: downAction }
    ControlAction {
        id: leftAction
        description: 'Left'
        iconName: 'go-previous'
        shortcut: shortcut_left
        shortcut1: shortcut_left1
        onTriggered: {
            log('debug', 'Moving left')
            sendCommand('"input.left"', '{}')
        }
    }
    SecondShortcutAction { mainAction: leftAction }
    ControlAction {
        id: rightAction
        description: 'Right'
        iconName: 'go-next'
        shortcut: shortcut_right
        shortcut1: shortcut_right1
        onTriggered: {
            log('debug', 'Moving right')
            sendCommand('"input.right"', '{}')
        }
    }
    SecondShortcutAction { mainAction: rightAction }
    ControlAction {
        id: backAction
        description: 'Back'
        iconName: 'edit-undo'
        shortcut: shortcut_back
        shortcut1: shortcut_back1
        onTriggered: {
            log('debug', 'Moving back')
            sendCommand('"Input.Back"', '{}')
        }
    }
    SecondShortcutAction { mainAction: backAction }
    ControlAction {
        id: homeAction
        description: 'Home'
        iconName: 'go-home'
        shortcut: shortcut_home
        shortcut1: shortcut_home1
        onTriggered: {
            log('debug', 'Going Home')
            sendCommand('"Input.Home"', '{}')
        }
    }
    SecondShortcutAction { mainAction: homeAction }
    ControlAction {
        id: selectAction
        description: 'Select'
        iconName: 'key-enter'
        shortcut: shortcut_select
        shortcut1: shortcut_select1
        onTriggered: {
            log('debug', 'Selecting item')
            sendCommand('"Input.Select"', '{}')
        }
    }
    SecondShortcutAction { mainAction: selectAction }
    ControlAction {
        id: contextAction
        description: 'Context'
        iconName: 'open-menu-symbolic.symbolic'
        shortcut: shortcut_context
        shortcut1: shortcut_context1
        onTriggered: {
            log('debug', 'Opening context menu')
            sendCommand('"Input.ContextMenu"', '{}')
        }
    }
    SecondShortcutAction { mainAction: contextAction }
    ControlAction {
        id: infoAction
        description: 'Info'
        iconName: 'help-about'
        shortcut: shortcut_info
        shortcut1: shortcut_info1
        onTriggered: {
            log('debug', 'Showing informations')
            sendCommand('"Input.Info"', '{}')
        }
    }
    SecondShortcutAction { mainAction: infoAction }

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
