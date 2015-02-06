import QtQuick 2.1
import QtQuick.Controls 1.1

Tab {
    id: mainTab
    title: 'Main Controls'
    //focus: true

    Rectangle {
        id: mainRec
        anchors.fill: parent
        color: colours.base
        property int marginVal: height / 20
        property int rowHeight: 20
        property int playerid: -1
        property string playertype: 'none'

        function stealFocus() {
            mainRec.focus = false
            mainRec.Keys.forwardTo = []
        }
        function returnFocus() {
            mainRec.focus = true
            mainRec.Keys.forwardTo = [generalControls, playerControls]
        }

        focus: true
        Keys.forwardTo: [generalControls, playerControls]

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
                margins: marginVal
            }
            height: ( mainRec.height - rowHeight ) / 2 - marginVal - 25
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
