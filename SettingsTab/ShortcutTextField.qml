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

import QtQuick 2.2
import QtQuick.Controls 1.2
import ".."

Rectangle {
    width: childrenRect.width
    height: childrenRect.height
    color: "transparent"
    property bool valid: true
    property bool unique: true
    property int arrayIndex: 0
    property string target: ''
    property string shortcut: frame[target]
    property string oldShortcut: frame[target]
    property alias text: textField.text

    Timer {
        id: updateTimer
        interval: 2000
        onTriggered: {
            if (textField.focus) {
                shortcutSettings.changeShortcut(
                    textField.text, oldShortcut, arrayIndex
                )
            }
        }
    }

    TextField {
        id: textField
        text: parent.shortcut
        onEditingFinished: {
            shortcutSettings.changeShortcut(text, oldShortcut, arrayIndex)
        }
        onTextChanged: {
            if (focus) {
                updateTimer.restart()
            }
        }
        onFocusChanged: {
            if (focus) {
                shortcutSettings.lastFocus = arrayIndex
            }
        }
    }

    Icon {
        anchors.left: textField.right
        anchors.leftMargin: 3
        iconName: (!valid) ? 'dialog-error' :
                  (!unique) ? 'dialog-warning' : 'empty'
        tooltip: (!valid) ? 'This is not a valid shortcut!' :
                 (!unique) ? 'You have already assigned this shortcut to another element.' :
                 ''
    }
}
