import QtQuick 2.1
import QtQuick.Controls 1.1

Rectangle {
    id: frame
    height: 300
    width: 500
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
                    setterMethod(eval('(' + curl.responseText + ')'))
                    if ( ! connected) {
                        console.log('Connection established.')
                        connected = true
                    }
                    //console.log(curl.responseText)
                } catch (e) {
                    if (connected) {
                        console.log('Connection lost.')
                        connected = false
                    }
                }
            }
        }
        curl.send(data)
    }

    TabView {
        id: tabView
        anchors.fill: parent
        focus: true
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
    }
}
