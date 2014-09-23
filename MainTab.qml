import QtQuick 2.1
import QtQuick.Controls 1.1

Tab {
    id: mainTab
    title: 'Main Controls'
    focus: true

    //onActiveChanged: {
        //if (active) {
            //forceActiveFocus()
        //}
    //}

    Rectangle {
        id: mainRec
        anchors.fill: parent
        color: colours.base
        property int marginVal: height / 20
        property int rowHeight: 20
        property int playerid: -1

        focus: true
        //Component.onCompleted: mainRec.forceActiveFocus()
        Keys.forwardTo: [generalControls, playerControls]

        GeneralControls {
            id: generalControls
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: marginVal
            }
            height: ( parent.height - rowHeight ) / 2 - marginVal
        }

        ChoosePlayerRow {
            id: choosePlayerRow
            anchors {
                top: generalControls.bottom
                left: parent.left
                right: parent.right
                leftMargin: 1
                rightMargin: 1
            }
            height: rowHeight
        }

        PlayerControls {
            id: playerControls
            anchors {
                top: choosePlayerRow.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: marginVal
            }
        }
    }
}
