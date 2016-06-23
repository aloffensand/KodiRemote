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

// A triangle with a base color and a borderColor for which you can set all
// three points. It points staight up by default.
Canvas {
    id: triangle
    property color borderColor: "black"
    property color color: "white"
    property point point1: width / 2 + ",0"
    property point point2: "0," + height
    property point point3: width + "," + height

    onPaint: {
        var context = getContext("2d");
        context.save()
        context.strokeStyle = borderColor
        context.fillStyle = color
        context.moveTo(point1.x, point1.y)
        context.lineTo(point2.x, point2.y)
        context.lineTo(point3.x, point3.y)
        context.closePath()
        context.fill()
        context.stroke()
        context.restore()
    }
}
