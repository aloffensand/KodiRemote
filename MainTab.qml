import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Tab {
    id: mainTab
    title: 'Main Controls'

    Rectangle {
        id: mainRec
        anchors.fill: parent
        color: "transparent"
        focus: true
        Keys.forwardTo: [generalControls, playerControls]
        property int marginVal: height / 20
        property int rowHeight: 20
        property int playerid: -1
        property string playertype: 'none'

        Timer {
            id: updateTimer
            interval: 1000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: {
                choosePlayerRow.updatePlayeridBox()
                playerControls.optionalTimer()
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: mainRec.focus = true
        }

        GeneralControls {
            id: generalControls
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: margins
            }
        }

        ChoosePlayerRow {
            id: choosePlayerRow
            anchors {
                top: generalControls.bottom
                left: parent.left
                right: parent.right
                leftMargin: 1
                rightMargin: 1
                topMargin: margins
            }
            //height: rowHeight
        }

        PlayerControls {
            id: playerControls
            anchors {
                top: choosePlayerRow.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: margins
            }
        }
    }
}
