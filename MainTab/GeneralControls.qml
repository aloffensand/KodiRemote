import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2

Rectangle {
    id: generalControls
    color: 'transparent'
    height: childrenRect.height
    width: childrenRect.width

    Shortcut {
        id: settingsShortcut
        sequence: shortcut_settings
        onActivated: log('debug', 'Settings')
    }
    Shortcut {
        id: settingsShortcut1
        sequence: shortcut_settings1
        onActivated: log('debug', 'Settings')
    }

    Action {
        id: sendUrlAction
        text: 'Send'
        tooltip: 'Send Video/Audio/Image Url (Enter while in input field)'
        onTriggered: {
            var raw_url = sendUrlTextBox.text
            log('debug', 'Parsing Url ' + raw_url)
            var youtube_prefix = 'plugin://plugin.video.youtube/?action=play_video&videoid='
            var regExp0 = /^.*(youtu.be\/|v\/|u\/w\/|embed\/|watch\?v=)([^#\&\?]*).*/
            var regExp1 = /^.*(youtube.com\/watch.*[\?\&]v=)([^#\&\?]*).*/
            var regExp2 = /^(mp4|mkv|mov|mp3|avi|flv|wmv|asf|flac|mka|m4a|aac|ogg|pls|jpg|jpeg|png|gif|tiff)$/
            var match0 = raw_url.match(regExp0)
            var match1 = raw_url.match(regExp1)
            var extension = raw_url.split('.').pop()
            if (match0 && match0[2].length == 11) {
                var send_url = youtube_prefix + match0[2]
            } else if (match1 && match1[2].length == 11) {
                var send_url = youtube_prefix + match1[2]
            } else if (regExp2.test(extension)) {
                var send_url = raw_url
            } else {
                log('notice', 'The requested url may not be supported:' + raw_url)
                var send_url = raw_url
            }
            log('debug', 'Sending Url ' + send_url)
            sendCommand('"Player.Open"', '{"item": {"file": "' + send_url + '"}}')
            mainRec.returnFocus()
        }
    }

    Action {
        id: sendTextAction
        text: 'Send'
        tooltip: 'Send text to the onscreen keyboard (Enter while in input field)'
        onTriggered: {
            log('debug', 'Sending text ' + sendTextTextBox.text)
            sendCommand('"Input.SendText"', '{"text": "' + sendTextTextBox.text + '"}')
            mainRec.returnFocus()
        }
    }

    GridLayout {
        id: movementGrid
        columnSpacing: 1
        rowSpacing: 1

        ControlButton {
            Layout.row: 1; Layout.column: 2
            description: 'Up'
            iconName: 'go-up'
            shortcut: shortcut_up
            shortcut1: shortcut_up1
            onClicked: {
                log('debug', 'Moving up')
                sendCommand('"input.up"', '{}')
            }
        }
        ControlButton {
            Layout.row: 3; Layout.column: 2
            description: "Down"
            iconName: 'go-down'
            shortcut: shortcut_down
            shortcut1: shortcut_down1
            onClicked: {
                log('debug', 'Moving down')
                sendCommand('"input.down"', '{}')
            }
        }
        ControlButton {
            Layout.row: 2; Layout.column: 1
            description: 'Left'
            iconName: 'go-previous'
            shortcut: shortcut_left
            shortcut1: shortcut_left1
            onClicked: {
                log('debug', 'Moving left')
                sendCommand('"input.left"', '{}')
            }
        }
        ControlButton {
            Layout.row: 2; Layout.column: 3
            description: 'Right'
            iconName: 'go-next'
            shortcut: shortcut_right
            shortcut1: shortcut_right1
            onClicked: {
                log('debug', 'Moving right')
                sendCommand('"input.right"', '{}')
            }
        }
        ControlButton {
            Layout.row: 2; Layout.column: 2
            description: 'Select'
            iconName: 'key-enter'
            shortcut: shortcut_select
            shortcut1: shortcut_select1
            onClicked: {
                log('debug', 'Selecting item')
                sendCommand('"Input.Select"', '{}')
            }
        }
    }

    GridLayout {
        id: additionalControlsGrid
        anchors.left: movementGrid.right
        anchors.margins: 5
        rowSpacing: 1; columnSpacing: 1

        ControlButton {
            Layout.row: 1; Layout.column: 1
            description: 'Back'
            iconName: 'edit-undo'
            shortcut: shortcut_back
            shortcut1: shortcut_back1
            onClicked: {
                log('debug', 'Moving back')
                sendCommand('"Input.Back"', '{}')
            }
        }
        ControlButton {
            Layout.row: 1; Layout.column: 2
            description: 'Home'
            iconName: 'go-home'
            shortcut: shortcut_home
            shortcut1: shortcut_home1
            onClicked: {
                log('debug', 'Going Home')
                sendCommand('"Input.Home"', '{}')
            }
        }
        ControlButton {
            Layout.row: 2; Layout.column: 1
            description: 'Context'
            iconName: 'open-menu-symbolic.symbolic'
            shortcut: shortcut_context
            shortcut1: shortcut_context1
            onClicked: {
                log('debug', 'Opening context menu')
                sendCommand('"Input.ContextMenu"', '{}')
            }
        }
        ControlButton {
            Layout.row: 2; Layout.column: 2
            description: 'Info'
            iconName: 'help-about'
            shortcut: shortcut_info
            shortcut1: shortcut_info1
            onClicked: {
                log('debug', 'Showing informations')
                sendCommand('"Input.Info"', '{}')
            }
        }

        ControlTextField {
            Layout.row: 1; Layout.column: 3
            Layout.preferredWidth: implicitWidth * 2.5
            id: sendTextTextBox
            width: implicitWidth * 2.5
            description: 'Enter text'
            shortcut: shortcut_enterText
            shortcut1: shortcut_enterText1
            onAccepted: sendTextAction.onTriggered()
        }
        Button { action: sendTextAction }

        ControlTextField {
            Layout.row: 2; Layout.column: 3
            Layout.preferredWidth: implicitWidth * 2.5
            id: sendUrlTextBox
            width: implicitWidth * 2.5
            description: 'Enter Url'
            shortcut: shortcut_enterUrl
            shortcut1: shortcut_enterUrl1
            onAccepted: sendUrlAction.onTriggered()
        }
        Button { action: sendUrlAction }
    }
}
