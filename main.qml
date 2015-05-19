import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import Qt.labs.settings 1.0

Window {
    id: frame

    height: 300
    width: 500
    visible: true

    SystemPalette {
        id: systemPalette
        colorGroup: SystemPalette.Active
    }

    property int margins: 10
    property int labelAlignment: Qt.AlignRight
    property string hostname: 'morgoth'
    property string port: '8080'
    property string xbmcUrl: 'http://' + hostname + ':' + port + '/jsonrpc'
    property bool connected: false
    property string loglevel: 'notice'

    // These are the loglevels defined in RFC5424, also used by rsyslog.
    // Except for 'none'.
    property var loglevels: {
        'none': -1,
        'error': 3,
        'warning': 4,
        'notice': 5,
        'info': 6,
        'debug': 7
    }

    property string shortcut_left: 'Left'
    property string shortcut_left1: ''
    property string shortcut_right: 'Right'
    property string shortcut_right1: ''
    property string shortcut_up: 'Up'
    property string shortcut_up1: ''
    property string shortcut_down: 'Down'
    property string shortcut_down1: ''
    property string shortcut_back: 'Backspace'
    property string shortcut_back1: ''
    property string shortcut_select: 'Return'
    property string shortcut_select1: 'Enter'
    property string shortcut_context: 'Menu'
    property string shortcut_context1: ''
    property string shortcut_info: 'I'
    property string shortcut_info1: ''
    property string shortcut_home: 'H'
    property string shortcut_home1: ''
    property string shortcut_enterText: 'T'
    property string shortcut_enterText1: ''
    property string shortcut_settings: ''
    property string shortcut_settings1: ''
    property string shortcut_playpause: 'Space'
    property string shortcut_playpause1: ''
    property string shortcut_stop: 'Escape'
    property string shortcut_stop1: ''
    property string shortcut_next: 'N'
    property string shortcut_next1: ''
    property string shortcut_previous: 'P'
    property string shortcut_previous1: ''
    property string shortcut_osd: 'O'
    property string shortcut_osd1: ''
    property string shortcut_playpauseselect: ''
    property string shortcut_playpauseselect1: ''

    Settings {
        category: 'Window'
        property alias x: frame.x
        property alias y: frame.y
        property alias width: frame.width
        property alias height: frame.height
    }
    Settings {
        category: 'Other'
        property alias hostname: frame.hostname
        property alias port: frame.port
        property alias loglevel: frame.loglevel
    }
    Settings {
        category: 'Shortcuts'
        property alias left: frame.shortcut_left
        property alias left1: frame.shortcut_left1
        property alias right: frame.shortcut_right
        property alias right1: frame.shortcut_right1
        property alias up: frame.shortcut_up
        property alias up1: frame.shortcut_up1
        property alias down: frame.shortcut_down
        property alias down1: frame.shortcut_down1
        property alias back: frame.shortcut_back
        property alias back1: frame.shortcut_back1
        property alias select: frame.shortcut_select
        property alias select1: frame.shortcut_select1
        property alias context: frame.shortcut_context
        property alias context1: frame.shortcut_context1
        property alias info: frame.shortcut_info
        property alias info1: frame.shortcut_info1
        property alias home: frame.shortcut_home
        property alias home1: frame.shortcut_home1
        property alias enterText: frame.shortcut_enterText
        property alias enterText1: frame.shortcut_enterText1
        property alias settings: frame.shortcut_settings
        property alias settings1: frame.shortcut_settings1
        property alias playpause: frame.shortcut_playpause
        property alias playpause1: frame.shortcut_playpause1
        property alias stop: frame.shortcut_stop
        property alias stop1: frame.shortcut_stop1
        property alias next: frame.shortcut_next
        property alias next1: frame.shortcut_next1
        property alias previous: frame.shortcut_previous
        property alias previous1: frame.shortcut_previous1
        property alias osd: frame.shortcut_osd
        property alias osd1: frame.shortcut_osd1
        property alias playpauseselect: frame.shortcut_playpauseselect
        property alias playpauseselect1: frame.shortcut_playpauseselect1
    }

    function sendCommand(methodString, paramsString) {
        requestData(methodString, paramsString, null)
    }

    function requestData(methodString, paramsString, setterMethod) {
        var curl = new XMLHttpRequest();
        var method = '"method": ' + methodString + ', ' +
                     '"params": ' + paramsString + ', '
        var data = '{"jsonrpc": "2.0", ' + method + '"id": "1"}'
        curl.open("POST", xbmcUrl, true)
        curl.setRequestHeader('Content-Type', 'application/json')

        curl.onreadystatechange = function() {
            if(curl.readyState == XMLHttpRequest.DONE) {
                try {
                    getResponse(method, methodString, eval('(' + curl.responseText + ')'), setterMethod)
                    if ( ! connected) {
                        connected = true
                    }
                } catch (e) {
                    //logToConsole(
                        //'debug',
                        //'Exception: "' + e + '"\n\t' +
                        //'readyState: ' + curl.readyState + '\n\t' +
                        //'responseText: "' + curl.responseText + '"'
                    //)
                    if (connected) {
                        connected = false
                    }
                }
            }
        }
        curl.send(data)
    }

    function getResponse(method, method_short, jsonObj, setterMethod) {
        if (jsonObj.error != null) {
            if ( ! expectedError(method, method_short, jsonObj.error)) {
                logToConsole('error', 
                    'Error processing request:\n\t' + method + '\n\t' +
                    jsonObj.error.code + ': ' +
                    jsonObj.error.message + '(' +
                    jsonObj.error.data + ')'
                )
                logToBox('error', 'Error sending ' + method_short)
            }
        } else if (setterMethod != null) {
            setterMethod(jsonObj)
        }
    }

    function expectedError(method, method_short, error) {
        // -32100: "Failed to execute method"
        if (error.code == '-32100') {
            // Requesting player properties when there is no player results in
            // an error. If the player changes after the host sent a reply to
            // updatePlayeridBox() and before it receives a player request,
            // these errors can (to my knowledge) not be prevented.
            // FIXME: ignoring them altogether isn't such a good idea though.
            if (method_short.indexOf('"Player.') == 0 &&
                ( ! (method_short == '"Player.GetActivePlayers"'))) {
                return true
            }
        }
    }

    function log(level, message) {
        logToConsole(level, message)
        logToBox(level, message)
    }

    function logToConsole(level, message) {
        if (loglevels[level] <= loglevels[loglevel]) {
            console.log(message)
        }
    }

    function logToBox(level, message) {
        if (loglevels[level] <= loglevels[loglevel]) {
            var messageText = message
            if (level == 'error') {
                var messageColor = 'red'
            } else if (level == 'warning') {
                var messageColor = 'yellow'
            } else {
                var messageColor = 'blue'
            }
            messageBox.showMessage(messageText, messageColor)
            messageTimer.restart()
        }
    }

    onConnectedChanged: {
        if (connected) {
            logToConsole('debug', 
                    new Date().toLocaleTimeString() +
                    ': Connection established.'
            )
            connectionBox.text = ''
        } else {
            logToConsole('warning',
                    new Date().toLocaleTimeString() +
                    ': Connection lost.'
            )
            connectionBox.text = 'Connection lost.'
        }
    }

    TabView {
        id: tabView
        anchors.fill: parent
        style: MyTabViewStyle {}

        onCurrentIndexChanged: {
            getTab(currentIndex).forceActiveFocus()
        }

        Rectangle {
            z: 1
            id: connectionBox
            anchors.top: parent.top
            anchors.right: parent.right
            width: 0
            height: 0
            border.width: 1
            border.color: 'black'
            radius: 2
            color: 'red'
            property string text: 'No connection found'
            states: State {
                name: "visible"; when: connectionBox.text != ''
                PropertyChanges {
                    target: connectionText
                    text: connectionBox.text
                }
                PropertyChanges {
                    target: connectionBox
                    width: connectionText.width + 4
                    height: connectionText.height + 4
                }
            }
            transitions: Transition {
                to: "visible"
                reversible: true
                SequentialAnimation {
                    PropertyAnimation {
                        target: connectionBox
                        properties: "width,x,y"
                        duration: 0
                    }
                    PropertyAnimation {
                        target: connectionBox
                        property: "height"
                        duration: 250
                    }
                }
            }

            Label {
                z: 1
                id: connectionText
                anchors.centerIn: parent
                text: ''
            }
        }

        Rectangle {
            z: 1
            id: messageBox
            anchors.top: connectionBox.bottom
            anchors.right: parent.right
            width: 0
            height: 0
            border.width: 1
            border.color: 'black'
            color: 'blue'
            property string text: ''
            property string lastText: ''
            property color lastColor: 'transparent'
            state: "hidden"

            function showMessage(text, col) {
                if (text == '') {
                    messageBox.state = "hidden"
                    messageBox.text = ''
                } else if (messageBox.state == "hidden") {
                    messageBox.text = text
                    messageBox.color = col
                    messageBox.state = "visible"
                } else {
                    messageBox.lastText = messageBox.text
                    messageBox.lastColor = messageBox.color
                    messageBox.state = "textChanged"
                    messageBox.text = text
                    messageBox.color = col
                    messageBox.state = "visible"
                }
            }

            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: messageBox
                        width: messageText.width + 4
                        height: messageText.height + 4
                        color: messageBox.color
                    }
                    PropertyChanges {
                        target: messageText
                        text: messageBox.text
                    }
                }, State {
                    name: "textChanged"
                    PropertyChanges {
                        target: messageBox
                        width: messageText.width + 4
                        height: messageText.height + 4
                        color: messageBox.lastColor
                    }
                    PropertyChanges {
                        target: messageText
                        text: messageBox.lastText
                    }
                }, State { name: "hidden" }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    reversible: true
                    SequentialAnimation {
                        PropertyAnimation {
                            target: messageBox
                            properties: "width,x,y"
                            duration: 0
                        }
                        PropertyAnimation {
                            target: messageBox
                            properties: "height"
                            duration: 150
                        }
                    }
                }, Transition {
                    from: "textChanged"
                    PropertyAnimation {
                        target: messageBox
                        properties: "width,color"
                        duration: 100
                    }
                }
            ]
            Label {
                id: messageText
                anchors.centerIn: parent
                text: ''
            }
        }

        Timer {
            id: messageTimer
            interval: 2500
            onTriggered: {
                messageBox.showMessage('', 'blue')
            }
        }


        MainTab {
            id: mainTab
            Component.onCompleted: forceActiveFocus()
        }
        VideoTab {
            id: videoTab
        }
        SettingsTab {
            id: settingsTab
        }
    }
}
