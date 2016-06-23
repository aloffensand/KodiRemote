/*
 * Copyright © 2015, 2016 Aina Lea Offensand
 * 
 * This file is part of KodiRemote.
 * 
 * KodiRemote is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * KodiRemote is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with KodiRemote.  If not, see <http://www.gnu.org/licenses/>.
 */

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
