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
