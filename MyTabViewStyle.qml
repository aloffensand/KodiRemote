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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

TabViewStyle {
    SystemPalette { id: colours; colorGroup: SystemPalette.Active }
    property color colHovered: Qt.tint(colours.highlight, 
        Qt.rgba(colours.base.r, colours.base.g, colours.base.b, 0.75))
    padding.top: 10
    tab: Rectangle {
        //color: styleData.selected ? colours.base :
               //styleData.hovered ? colHovered :
               //colours.alternateBase
        color: styleData.selected ? colours.base :
               styleData.hovered ? colHovered :
               colours.window
        implicitHeight: text.height + 4
        implicitWidth: Math.max(text.width + 13, 50)
        radius: 2
        border.width: 1
        border.color: colours.shadow
        Label {
            id: text
            anchors.centerIn: parent
            font.pixelSize: 13
            font.underline: styleData.activeFocus
            //color: styleData.selected ? colours.highlightedText :
                   //colours.buttonText
            color: colours.buttonText
            text: styleData.title
        }
    }
    tabBar: Rectangle {
        color: colours.window
        Rectangle {
            anchors {
                bottom: parent.bottom
                left: parent.left; right: parent.right
            }
            height: 1
            color: colours.windowText
        }
    }
    frame: Rectangle {
        color: colours.window
    }
    frameOverlap: 0
}
