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

import QtQuick 2.5
import QtQuick.Controls 1.1

Rectangle {
    z: 1
    id: connectionBox
    width: 0
    height: 0
    border.width: 1
    border.color: 'black'
    radius: 2
    color: 'red'
    property string text: 'No connection found'
    states: State {
        name: "visible"; when: connectionBox.text != ''
        PropertyChanges {
            target: connectionText
            text: connectionBox.text
        }
        PropertyChanges {
            target: connectionBox
            width: connectionText.width + 4
            height: connectionText.height + 4
        }
    }
    transitions: Transition {
        to: "visible"
        reversible: true
        SequentialAnimation {
            PropertyAnimation {
                target: connectionBox
                properties: "width,x,y"
                duration: 0
            }
            PropertyAnimation {
                target: connectionBox
                property: "height"
                duration: 250
            }
        }
    }

    Label {
        z: 1
        id: connectionText
        anchors.centerIn: parent
        text: ''
    }
}