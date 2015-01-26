import QtQuick 2.1
import QtQuick.Controls 1.1

Rectangle {
    id: generalControls
    color: 'transparent'

    //focus: true

    Keys.onUpPressed: upAction.onTriggered()
    Keys.onDownPressed: downAction.onTriggered()
    Keys.onLeftPressed: leftAction.onTriggered()
    Keys.onRightPressed: rightAction.onTriggered()
    //Keys.onBackspacePressed: backAction.onTriggered()
    Keys.onReturnPressed: selectAction.onTriggered()
    Keys.onEnterPressed: selectAction.onTriggered()
    Keys.onMenuPressed: contextAction.onTriggered()

    Keys.onPressed: {
        if (event.key == Qt.Key_Backspace) {
            backAction.onTriggered()
            event.accepted = true
        } else if (event.key == Qt.Key_T) {
            textBox.focus = true
            event.accepted = true
        } else if (event.key == Qt.Key_I) {
            infoAction.onTriggered()
            event.accepted = true
        }
    }

    Action {
        id: upAction
        text: 'Up'
        tooltip: 'Up (Up Arrow)'
        onTriggered: {
            console.log('Moving up')
            sendCommand('"input.up"', '{}')
        }
    }
    Action {
        id: downAction
        text: "Down"
        tooltip: 'Down (Down Arrow)'
        onTriggered: {
            console.log('Moving down')
            sendCommand('"input.down"', '{}')
        }
    }
    Action {
        id: leftAction
        text: 'Left'
        tooltip: 'Left (Left Arrow)'
        onTriggered: {
            console.log('Moving left')
            sendCommand('"input.left"', '{}')
        }
    }
     Action {
        id: rightAction
        text: 'Right'
        tooltip: 'Right (Right Arrow)'
        onTriggered: {
            console.log('Moving right')
            sendCommand('"input.right"', '{}')
        }
    }
    Action {
        id: backAction
        text: 'Back'
        tooltip: 'Back (Backspace)'
        shortcut: StandardKey.Back
        onTriggered: {
            console.log('Moving back')
            sendCommand('"Input.Back"', '{}')
        }
    }
    Action {
        id: homeAction
        text: 'Home'
        tooltip: 'Home ()'
        onTriggered: {
            console.log('Going Home')
            sendCommand('"Input.Home"', '{}')
        }
    }
    Action {
        id: selectAction
        text: 'Select'
        tooltip: 'Select (Return/Enter)'
        onTriggered: {
            console.log('Selecting item')
            sendCommand('"Input.Select"', '{}')
        }
    }
    Action {
        id: contextAction
        text: 'Context'
        tooltip: 'Context Menu (Context menu)'
        onTriggered: {
            console.log('Opening context menu')
            sendCommand('"Input.ContextMenu"', '{}')
        }
    }
    Action {
        id: infoAction
        text: 'Info'
        tooltip: 'Information (i)'
        onTriggered: {
            console.log('Showing informations')
            sendCommand('"Input.Info"', '{}')
        }
    }

    Action {
        id: sendTextAction
        text: 'Send'
        tooltip: 'Send text (Enter while in input field)'
        onTriggered: {
            console.log('Sending text ' + textBox.text)
            sendCommand('"Input.SendText"', '{"text": ' + textBox.text + '}')
            generalControls.focus = true
        }
    }

    Grid {
        id: controlGrid
        columns: 3
        Button {
            action: backAction
        }
        Button {
            action: upAction
        }
        Button {
            action: infoAction
        }
        Button {
            action: leftAction
        }
        Button {
            action: selectAction
        }
        Button {
            action: rightAction
        }
        Button {
            action: homeAction
        }
        Button {
            action: downAction
        }
        Button {
            action: contextAction
        }
    }
    Row {
        anchors.left: controlGrid.right
        anchors.leftMargin: 5
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
