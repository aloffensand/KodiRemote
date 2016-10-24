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
    id: messageBox
    width: 0
    height: 0
    border.width: 1
    border.color: 'black'
    color: 'blue'
    property string text: ''
    property string lastText: ''
    property color lastColor: 'transparent'
    state: "hidden"

    function showMessage(text, col) {
        if (text == '') {
            messageBox.state = "hidden"
            messageBox.text = ''
        } else if (messageBox.state == "hidden") {
            messageBox.text = text
            messageBox.color = col
            messageBox.state = "visible"
        } else {
            messageBox.lastText = messageBox.text
            messageBox.lastColor = messageBox.color
            messageBox.state = "textChanged"
            messageBox.text = text
            messageBox.color = col
            messageBox.state = "visible"
        }
        messageTimer.restart()
    }

    // Hide the messageBox after <interval> milliseconds.
    Timer {
        id: messageTimer
        interval: 2500
        onTriggered: {
            messageBox.showMessage('', 'blue')
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: messageBox
                width: messageText.width + 4
                height: messageText.height + 4
                color: messageBox.color
            }
            PropertyChanges {
                target: messageText
                text: messageBox.text
            }
        }, State {
            name: "textChanged"
            PropertyChanges {
                target: messageBox
                width: messageText.width + 4
                height: messageText.height + 4
                color: messageBox.lastColor
            }
            PropertyChanges {
                target: messageText
                text: messageBox.lastText
            }
        }, State { name: "hidden" }
    ]
    transitions: [
        Transition {
            from: "hidden"
            reversible: true
            SequentialAnimation {
                PropertyAnimation {
                    target: messageBox
                    properties: "width,x,y"
                    duration: 0
                }
                PropertyAnimation {
                    target: messageBox
                    properties: "height"
                    duration: 150
                }
            }
        }, Transition {
            from: "textChanged"
            PropertyAnimation {
                target: messageBox
                properties: "width,color"
                duration: 100
            }
        }
    ]
    Label {
        id: messageText
        anchors.centerIn: parent
        text: ''
    }
}
