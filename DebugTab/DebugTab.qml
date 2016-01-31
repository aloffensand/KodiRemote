import QtQuick 2.5
import QtQuick.Controls 1.3

Tab {
    id: debugTab
    title: 'Debug'

    Rectangle {
        anchors.fill: parent
        color: 'transparent'
        focus: true

        Button {
            text: 'Log current requests'
            onClicked: logCurrentRequests()
        }
    }
}
