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
        var curl = new XMLHttpRequest();
        var data = '{"jsonrpc": "2.0", ' +
                   '"method": ' + methodString + ', ' +
                   '"params": ' + paramsString + ', ' +
                   '"id": "1"}'
        curl.open("POST", xbmcUrl, true)
        curl.setRequestHeader('Content-Type', 'application/json')
        curl.send(data)
    }

    function requestData(methodString, paramsString, setterMethod) {
        var curl = new XMLHttpRequest();
        var data = '{"jsonrpc": "2.0", ' +
                   '"method": ' + methodString + ', ' +
                   '"params": ' + paramsString + ', ' +
                   '"id": "1"}'
        curl.open("POST", xbmcUrl, true)
        curl.setRequestHeader('Content-Type', 'application/json')

        curl.onreadystatechange = function() {
            if(curl.readyState == curl.DONE) {
                try {
                    //setterMethod(eval('(' + curl.responseText + ')'))
                    callSetterMethod(eval('(' + curl.responseText + ')'), setterMethod)
                    if ( ! connected) {
                        console.log(new Date().toLocaleTimeString() +
                                    'Connection established.')
                        connected = true
                    }
                    //console.log(curl.responseText)
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

    function callSetterMethod(jsonObj, setterMethod) {
        if (jsonObj.error != null) {
            console.error('Error ' + jsonObj.error.code + ': ' +
                          jsonObj.error.message + '(' +
                          jsonObj.error.data + ')')
        } else {
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
