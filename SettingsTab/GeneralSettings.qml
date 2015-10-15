import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1


GridLayout {
    columns: 3

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

    Label { text: 'Host: '; Layout.alignment: labelAlignment }
    TextField {
        id: hostText
        Layout.columnSpan: 2
        Layout.fillWidth: true
        text: hostname
    }
    Label { text: 'Port: '; Layout.alignment: labelAlignment }
    TextField {
        id: portText
        Layout.columnSpan: 2
        text: port
    }

    Label { text: 'Loglevel: '; Layout.alignment: labelAlignment }
    ComboBox {
        id: loglevelBox
        //tooltip: 'How much information should be shown'
        model: ['debug', 'info', 'notice', 'warning', 'error', 'none']
        currentIndex: loglevel == 'none' ? 5 :
                      7 - loglevels[loglevel]
        Layout.columnSpan: 2
    }

    Label { text: ' '; Layout.columnSpan: 2 }
    Button { action: applyAction; Layout.alignment: Qt.AlignRight }
}
