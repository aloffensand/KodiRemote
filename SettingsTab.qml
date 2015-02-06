import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Tab {
    id: settingsTab
    title: 'Settings'


    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: parent.height / 20

        Action {
            id: applyAction
            text: 'Apply'
            onTriggered: {
                console.log('applied.')
            }
        }

        Text {
            text: 'Host: '
        }
        TextField {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: 'http://morgoth:8080/jsonrpc'
        }

        // makes sure all other elements are aligned at the top
        Rectangle {
            id: invisiRec
            Layout.fillHeight: true
            Layout.columnSpan: 3
        }

        Button {
            action: applyAction
        }
    }
}
