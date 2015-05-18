import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1


GridLayout {
    columns: 3
    anchors.fill: parent
    anchors.margins: parent.height / 20

    ApplyAction {
        id: applyAction
        onTriggered: {
            log('debug', 'Applying general settings.')
            hostname = hostText.text
            port = portText.text
            loglevel = loglevelBox.currentText
        }
    }
    BackAction { id: backAction }

    Label { text: 'Host: ' }
    TextField {
        id: hostText
        Layout.columnSpan: 2
        Layout.fillWidth: true
        text: hostname
    }
    Label { text: 'Port: ' }
    TextField {
        id: portText
        Layout.columnSpan: 2
        text: port
    }

    Label { text: 'Loglevel: ' }
    ComboBox {
        id: loglevelBox
        //tooltip: 'How much information should be shown'
        model: ['debug', 'info', 'notice', 'warning', 'error', 'none']
        currentIndex: loglevel == 'none' ? 5 :
                      7 - loglevels[loglevel]
        Layout.columnSpan: 2
    }

    // makes sure all other elements are aligned at the top
    Rectangle {
        Layout.fillHeight: true
        Layout.columnSpan: 3
        color: "transparent"
    }
    Button { action: backAction }
    Label { text: ' ' }
    Button { action: applyAction; Layout.alignment: Qt.AlignRight }
}
