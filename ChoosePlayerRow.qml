import QtQuick 2.1
import QtQuick.Controls 1.1

Row {
    function setActivePlayerList(jsonObj) {
        var newList = [ '-1: none' ]
        jsonObj.result.forEach(function(player) {
            newList.push('' + player.playerid + ': ' + player.type)
        })
        if (playeridBox.model != newList) {
            playeridBox.model = newList
        }
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        width: 20
        color: 'black'
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: ' Active Player:  '
    }
    ComboBox {
        id: playeridBox
        anchors.verticalCenter: parent.verticalCenter
        onHoveredChanged: {
            requestData('"Player.GetActivePlayers"', '{}', setActivePlayerList)
        }
        onActivated: {
            var temp = model[index]
            playerid = temp.split(":")[0]
            console.log(playerid)
            //playerid = index - 1
        }
    }
    Text {
        text: '  '
    }
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        width: parent.width - x - 1
        color: 'black'
    }
}

//Rectangle {
    //Rectangle {
        //height: 1
        //width: parent.width
        //y: parent.height / 2
        //color: 'black'
    //}
    //Rectangle {
        //id: txtRec
        //width: txt.width
        //height: txt.height
        //anchors.verticalCenter: parent.verticalCenter
        //x: 20
        //Text {
            //id: txt
            ////anchors {
                ////verticalCenter: parent.verticalCenter
            ////}
            ////x: 20
            //text: 'Active Player: '
        //}
    //}
    //ComboBox {
        //anchors {
            //left: txtRec.right
            //verticalCenter: parent.verticalCenter
        //}
    //}
//}
