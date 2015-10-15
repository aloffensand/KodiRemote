import QtQuick 2.1
import QtQuick.Controls 1.1

// A ComboBox to choose which player to send controls to and some visual stuff.
Row {
    width: parent.width

    Component.onCompleted: {
        addNotificationFunction('Player.OnPlay', updatePlayeridBox)
        addNotificationFunction('Player.OnStop', updatePlayeridBox)
        addNotificationFunction('Internal.OnConnectionEstablished', updatePlayeridBox)
    }

    function setActivePlayerList(jsonObj) {
        var newList = [ '-1: none' ]
        var players = jsonObj.result
        var equal = (players.length == playeridBox.model.length - 1)
        for (var i = 0; i < players.length; i++) {
            var playerStr = players[i].playerid + ': ' + players[i].type
            newList.push(playerStr)
            if (playerStr != playeridBox.model[i + 1]) {
                equal = false
            }
        }
        if (! equal) {
            playeridBox.model = newList
            if (playerid == -1 && newList.length > 1) {
                playeridBox.currentIndex = 1
            }
        }
    }

    function updatePlayeridBox(params) {
        requestData('"Player.GetActivePlayers"', '{}', setActivePlayerList)
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        width: 20
        color: systemPalette.text
    }
    Label {
        anchors.verticalCenter: parent.verticalCenter
        text: ' Active Player:  '
    }
    ComboBox {
        id: playeridBox
        anchors.verticalCenter: parent.verticalCenter
        onHoveredChanged: {
            updatePlayeridBox()
        }
        // Update playerid and playertype if they have changed.
        onCurrentIndexChanged: {
            if (model[currentIndex] == null) {
                return
            }
            var temp = model[currentIndex]
            var tempid = temp.split(':')[0]
            var temptype = temp.split(':')[1]
            if (playerid != tempid) {
                playerid = tempid
            }
            if (playertype != temptype) {
                playertype = temp.split(": ")[1]
            }
        }
    }
    Text {
        text: '  '
    }
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        width: parent.width - x - 1
        color: systemPalette.text
    }
}
