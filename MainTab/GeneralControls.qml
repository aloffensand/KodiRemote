import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    id: generalControls
    color: 'transparent'
    height: childrenRect.height
    width: childrenRect.width

    ControlAction {
        id: enterTextAction
        description: 'Enter text'
        shortcut: shortcut_enterText
        shortcut1: shortcut_enterText1
        onTriggered: sendTextTextBox.focus = true
    }
    SecondShortcutAction { mainAction: enterTextAction }

    ControlAction {
        id: enterUrlAction
        description: 'Enter Url'
        shortcut: shortcut_enterUrl
        shortcut1: shortcut_enterUrl1
        onTriggered: sendUrlTextBox.focus = true
    }
    SecondShortcutAction { mainAction: enterUrlAction }

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
                log('error', 'The requested url is not supported:' + raw_url)
                return
            }
            log('debug', 'Sending Url ' + send_url)
            sendCommand('"Player.Open"', '{"item": {"file": "' + send_url + '"}}')
        }
    }

    Action {
        id: sendTextAction
        text: 'Send'
        tooltip: 'Send text to the onscreen keyboard (Enter while in input field)'
        onTriggered: {
            log('debug', 'Sending text ' + sendTextTextBox.text)
            sendCommand('"Input.SendText"', '{"text": "' + sendTextTextBox.text + '"}')
            generalControls.focus = true
        }
    }

    Grid {
        id: controlGrid
        columns: 6
        Button { action: backAction }
        Button { action: upAction }
        Button { action: infoAction }
        Text { text: ' ' }
        Text { text: ' ' }
        Text { text: ' ' }

        Button { action: leftAction }
        Button { action: selectAction }
        Button { action: rightAction }
        Text { text: ' ' }
        TextField {
            id: sendTextTextBox
            placeholderText: enterTextAction.tooltip
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
        Button { action: sendTextAction }

        Button { action: homeAction }
        Button { action: downAction }
        Button { action: contextAction }
        Text { text: ' ' }
        TextField {
            id: sendUrlTextBox
            placeholderText: enterUrlAction.tooltip
            onAccepted: sendUrlAction()
            Keys.onPressed: {
                if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                    sendUrlAction.onTriggered()
                    event.accepted = true
                } else if (event.key == Qt.Key_Escape) {
                    generalControls.focus = true
                    event.accepted = true
                }
            }
        }
        Button { action: sendUrlAction }
    }
}
