/*
 * Copyright © 2016 Aina Lea Offensand
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

import QtQuick 2.5
import QtQuick.Controls 1.2

// A Button with some preset values that generates shortcuts.
// The tooltip is generated from the description and the associated
// shortcut(s).

Button {
    id: button
    property string description: ''
    property string shortcut: ''
    property string shortcut1: ''
    iconSource: 'qrc:///icons/' + iconName + '.png'
    tooltip: {
        var str = description
        if (shortcut + shortcut1 != '') {
            str += ' ('
            if (shortcut != '' && shortcut1 != '') {
                str += shortcut + ', ' + shortcut1 + ')'
            } else {
                str += shortcut + shortcut1 + ')'
            }
        }
        return str
    }

    Shortcut {
        sequence: button.shortcut
        onActivated: button.clicked()
        enabled: button.enabled && mainRec.shortcutFocus
    }
    Shortcut {
        sequence: button.shortcut1
        onActivated: button.clicked()
        enabled: button.enabled && mainRec.shortcutFocus
    }
}
