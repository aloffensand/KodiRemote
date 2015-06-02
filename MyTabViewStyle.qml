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
