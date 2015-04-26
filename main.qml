import QtQuick 2.1
import QtQuick.Controls 1.1

Rectangle {
    id: frame
    height: 300
    width: 500
    //property string xbmcUrl: 'http://192.168.178.240:8080/jsonrpc'
    property string xbmcUrl: 'http://morgoth:8080/jsonrpc'
    property bool connected: false

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
                    getResponse(method, eval('(' + curl.responseText + ')'), setterMethod)
                    if ( ! connected) {
                        console.log(new Date().toLocaleTimeString() +
                                    'Connection established.')
                        connected = true
                    }
                } catch (e) {
                    if (connected) {
                        console.log(new Date().toLocaleTimeString() +
                                    'Connection lost.')
                        connected = false
                    }
                }
            }
        }
        curl.send(data)
    }

    function getResponse(method, jsonObj, setterMethod) {
        if (jsonObj.error != null) {
            console.error('Error sending request\n\t' + method + ':\n\t' +
                          jsonObj.error.code + ': ' +
                          jsonObj.error.message + '(' +
                          jsonObj.error.data + ')')
        } else if (setterMethod != null) {
            setterMethod(jsonObj)
        }
    }

    TabView {
        id: tabView
        anchors.fill: parent
        style: MyTabViewStyle {}

        onCurrentIndexChanged: {
            getTab(currentIndex).forceActiveFocus()
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
