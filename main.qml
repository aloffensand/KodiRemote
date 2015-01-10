import QtQuick 2.1
import QtQuick.Controls 1.1

Rectangle {
    id: frame
    height: 300
    width: 500
    property string xbmcUrl: 'http://morgoth:8080/jsonrpc'
    //property int playerid: 1

    SystemPalette {
        id: colours
        colorGroup: SystemPalette.Active
    }

    function sendCommand(methodString, paramsString) {
    var curl = new XMLHttpRequest();
    var data = '{"jsonrpc": "2.0", '
               + '"method": ' + methodString + ', '
               + '"params": ' + paramsString + ', '
               + '"id": "1"}'
    curl.open("POST", xbmcUrl, true)
    curl.setRequestHeader('Content-Type', 'application/json')
    curl.send(data)
    }

    function requestData(methodString, paramsString, setterMethod) {
    var curl = new XMLHttpRequest();
    var data = '{"jsonrpc": "2.0", '
               + '"method": ' + methodString + ', '
               + '"params": ' + paramsString + ', '
               + '"id": "1"}'
    curl.open("POST", xbmcUrl, true)
    curl.setRequestHeader('Content-Type', 'application/json')

    curl.onreadystatechange = function() {
      if(curl.readyState == curl.DONE) {
        setterMethod(eval('(' + curl.responseText + ')'))
        //console.log(curl.responseText)
      }
    }
    curl.send(data)
    }

    //function recursiveFocusFinder(parentItem, depth) {
        //for (var i=0; i < parentItem.children.length; i++) {
            //var chld = parentItem.children[i]
            //console.log(depth + chld + '\t' + chld.focus + ' ' + chld.activeFocus)
            //recursiveFocusFinder(chld, depth + '>')
        //}
    //}

    //Button {
        //id: findFocus
        //z: 10
        //text: 'findFocus'
        //onClicked: {
            //recursiveFocusFinder(frame, '')
        //}
    //}

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
        Tab {
            title: 'red'
            Rectangle {
                id: reccy
                anchors.fill: parent
                color: 'red'
                focus: true
                Keys.onPressed: {
                    console.log('ean')
                    event.accepted = true
                }
            }
        }
    }
}
