import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    id: generalControls
    color: 'transparent'

    //focus: true

    //Keys.onReturnPressed: selectAction.onTriggered()
    //Keys.onEnterPressed: selectAction.onTriggered()

    Keys.onPressed: {
        if (event.key == Qt.Key_T) {
            textBox.focus = true
            event.accepted = true
        }
        //if (event.key == Qt.Key_Backspace) {
            //backAction.onTriggered()
            //event.accepted = true
        //} else if (event.key == Qt.Key_T) {
            //textBox.focus = true
            //event.accepted = true
        //} else if (event.key == Qt.Key_I) {
            //infoAction.onTriggered()
            //event.accepted = true
        //}
    }

    Action {
        id: settingsAction
        shortcut: StandardKey.Preferences
        onTriggered: log('debug', 'Settings')
    }

    Action {
        id: upAction
        text: 'Up'
        tooltip: 'Up (Up Arrow)'
        shortcut: 'Up'
        onTriggered: {
            log('debug', 'Moving up')
            sendCommand('"input.up"', '{}')
        }
    }
    Action {
        id: downAction
        text: "Down"
        tooltip: 'Down (Down Arrow)'
        shortcut: 'Down'
        onTriggered: {
            log('debug', 'Moving down')
            sendCommand('"input.down"', '{}')
        }
    }
    Action {
        id: leftAction
        text: 'Left'
        tooltip: 'Left (Left Arrow)'
        shortcut: 'Left'
        onTriggered: {
            log('debug', 'Moving left')
            sendCommand('"input.left"', '{}')
        }
    }
     Action {
        id: rightAction
        text: 'Right'
        tooltip: 'Right (Right Arrow)'
        shortcut: 'Right'
        onTriggered: {
            log('debug', 'Moving right')
            sendCommand('"input.right"', '{}')
        }
    }
    Action {
        id: backAction
        text: 'Back'
        tooltip: 'Back (Backspace)'
        shortcut: 'Backspace'
        //shortcut: StandardKey.Back
        onTriggered: {
            log('debug', 'Moving back')
            sendCommand('"Input.Back"', '{}')
        }
    }
    Action {
        id: homeAction
        text: 'Home'
        tooltip: 'Home ()'
        shortcut: ''
        onTriggered: {
            log('debug', 'Going Home')
            sendCommand('"Input.Home"', '{}')
        }
    }
    Action {
        id: selectAction
        text: 'Select'
        tooltip: 'Select (Return)'
        //shortcut: ['Return', 'Enter']
        shortcut: 'Return'
        //shortcut: "E" // e
        //shortcut: "E,A" // this way, you have to press e and then a.
        //shortcut: "s,e,l,e,c,t" // now you have to press sele.
        //shortcut: "E","A" // only a
        //shortcut: ("E","A") // only a
        //shortcut: ["E","A"] // nothing
        //shortcut: ("E"),("A") // only a
        //shortcut: ("A"),("E") // only e
        onTriggered: {
            log('debug', 'Selecting item')
            sendCommand('"Input.Select"', '{}')
        }
    }
    Action {
        id: contextAction
        text: 'Context'
        tooltip: 'Context Menu (Context menu)'
        shortcut: 'Menu'
        onTriggered: {
            log('debug', 'Opening context menu')
            sendCommand('"Input.ContextMenu"', '{}')
        }
    }
    Action {
        id: infoAction
        text: '&Info'
        tooltip: 'Information (i)'
        shortcut: 'I'
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
