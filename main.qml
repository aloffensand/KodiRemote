import QtQuick 2.1
import QtQuick.Controls 1.1

Rectangle {
    id: frame
    height: 300
    width: 500
    //property string xbmcUrl: 'http://192.168.178.240:8080/jsonrpc'
    property string xbmcUrl: 'http://morgoth:8080/jsonrpc'
    property bool connected: false
    //property string loglevel: 'error'
    property string loglevel: 'debug'

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

    SystemPalette {
        id: colours
        colorGroup: SystemPalette.Active
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
            if(curl.readyState == curl.DONE) {
                try {
                    getResponse(method, methodString, eval('(' + curl.responseText + ')'), setterMethod)
                    if ( ! connected) {
                        connected = true
                    }
                } catch (e) {
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
            logToConsole('error', 
                'Error sending request\n\t' + method + ':\n\t' +
                jsonObj.error.code + ': ' +
                jsonObj.error.message + '(' +
                jsonObj.error.data + ')'
            )
            logToBox('error', 'Error sending ' + method_short)
        } else if (setterMethod != null) {
            setterMethod(jsonObj)
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
            messageText.text = message
            if (level == 'error') {
                messageBox.color = 'red'
            } else if (level == 'warning') {
                messageBox.color = 'yellow'
            } else {
                messageBox.color = 'blue'
            }
        }
    }

    onConnectedChanged: {
        if (connected) {
            logToConsole('debug', 
                    new Date().toLocaleTimeString() +
                    ': Connection established.'
            )
            connectionText.text = ''
        } else {
            logToConsole('warning',
                    new Date().toLocaleTimeString() +
                    ': Connection lost.'
            )
            connectionText.text = 'Connection lost.'
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
            width: connectionText.width == 0 ? 0 : connectionText.width + 4
            height: connectionText.width == 0 ? 0 : connectionText.height + 4
            color: 'red'
            border.width: 1
            border.color: 'black'
            radius: 2

            Text {
                z: 1
                anchors.centerIn: parent
                id: connectionText
                text: 'No connection found'
            }
        }

        Rectangle {
            z: 1
            id: messageBox
            anchors.top: connectionBox.bottom
            anchors.right: parent.right
            width: messageText.width == 0 ? 0 : messageText.width + 4
            height: messageText.width == 0 ? 0 : messageText.height + 4
            color: 'blue'
            border.width: 1
            border.color: 'black'
            Text {
                id: messageText
                anchors.centerIn: parent
                text: ''
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
