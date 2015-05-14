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
                log('debug', 'Applying Settings.')
                hostname = hostText.text
                port = portText.text
                loglevel = loglevelBox.currentText
                shortcut_left = 'Left'
                    //'right': 'Right', 
                    //'up': 'Up',
                    //'down': 'Down',
                    //'back': 'Backspace', 
                shortcut_select = shortcutSelectText.text
                    //'context': 'Menu',
                    //'info': 'i',
                    //'home': 'h',
                    //'enterText': 't',
                    //'settings': '',
                    //'playpause': 'Space',
                    //'stop': 'Escape',
                    //'next': 'n',
                    //'previous': 'p'
            }
        }

        Text { text: 'Host: ' }
        TextField {
            id: hostText
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: hostname
        }
        Text { text: 'Port: ' }
        TextField {
            id: portText
            Layout.columnSpan: 2
            text: port
        }

        Text { text: 'Loglevel: ' }
        ComboBox {
            id: loglevelBox
            //tooltip: 'How much information should be shown'
            model: ['debug', 'info', 'notice', 'warning', 'error', 'none']
            currentIndex: loglevel == 'none' ? 5 :
                          7 - loglevels[loglevel]
            Layout.columnSpan: 2
        }

        Text { text: 'Shortcuts' }
        Text { text: 'Select' }
        TextField {
            id: shortcutSelectText
            text: shortcut_select
        }

        // makes sure all other elements are aligned at the top
        Rectangle {
            id: invisiRec
            Layout.fillHeight: true
            Layout.columnSpan: 3
        }

        Button { action: applyAction }
    }
}
