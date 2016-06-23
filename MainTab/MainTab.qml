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

Tab {
    id: mainTab
    title: 'Main Controls'

    // Just a container for it's elements
    // GeneralControls, ChoosePlayerRow and PlayerControls.
    // Ensures they can exchange the necessary information
    // (mainly playerid and playertype)
    Rectangle {
        id: mainRec
        anchors.fill: parent
        color: "transparent"
        focus: true
        property bool shortcutFocus: focusCatcher.focus
        Keys.forwardTo: [generalControls, playerControls]
        property int marginVal: height / 20
        property int rowHeight: 20
        property int playerid: -1
        property string playertype: 'none'

        Item {
            id: focusCatcher
            focus: false
            Component.onCompleted: focus = true
        }

        function returnFocus() {
            focusCatcher.focus = true
        }

        // Poll for information every <interval> milliseconds
        Timer {
            id: updateTimer
            interval: 1000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: {
                //choosePlayerRow.updatePlayeridBox()
                playerControls.optionalTimer()
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: focusCatcher.focus = true
        }

        GeneralControls {
            id: generalControls
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: margins
            }
        }

        ChoosePlayerRow {
            id: choosePlayerRow
            anchors {
                top: generalControls.bottom
                left: parent.left
                right: parent.right
                leftMargin: 1
                rightMargin: 1
                topMargin: margins
            }
            //height: rowHeight
        }

        PlayerControls {
            id: playerControls
            anchors {
                top: choosePlayerRow.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: margins
            }
        }
    }
}
