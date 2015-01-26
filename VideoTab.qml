import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.1

Tab {
    id: videoTab
    title: "Videos"
    Rectangle {
        anchors {
            fill: parent
            margins: 8
        }
        color: "transparent"

        function setSeriesModel(jsonObj) {
            var newModel = []
            jsonObj.result.tvshows.forEach(function(show) {
                var banner1 = show.art.banner.slice(8, show.art.banner.length-1)
                var banner = banner1.replace(/%3a/g, ":").replace(/%2f/g, "/")
                //var thumb1 = show.art.thumb.slice(8, show.art.thumb.length-1)
                //var thumb = thumb1.replace(/%3a/g, ":").replace(/%2f/g, "/")
                var poster1 = show.art.poster.slice(8, show.art.poster.length-1)
                var poster = poster1.replace(/%3a/g, ":").replace(/%2f/g, "/")
                var fanart1 = show.art.fanart.slice(8, show.art.fanart.length-1)
                var fanart = fanart1.replace(/%3a/g, ":").replace(/%2f/g, "/")
                var fanart3 = show.fanart.slice(8, show.fanart.length-1)
                var fanart2 = fanart3.replace(/%3a/g, ":").replace(/%2f/g, "/")
                var thumbnail1 = show.thumbnail.slice(8, show.thumbnail.length-1)
                var thumbnail = thumbnail1.replace(/%3a/g, ":").replace(/%2f/g, "/")

                newModel.push({title: show.title,
                               art: banner,
                               //art2: thumb,
                               art3: poster,
                               art4: fanart,
                               art5: fanart2,
                               art6: thumbnail
                })
            })
            console.log(newModel[0].title)
            console.log(newModel[0].art)
            //seriesTable.otherModel = newModel
            //seriesTable.model = newModel.length
            seriesTable.model = newModel
        }

        MessageDialog {
            id: vidScanDialog
            icon: StandardIcon.Question
            text: "Are you sure you want to scan the video library? Depending on the size, this may take a while."
            standardButtons: StandardButton.Ok | StandardButton.Cancel
            onAccepted: {
                sendCommand('"VideoLibrary.Scan"', '{}')
            }
        }

        Button {
            id: scanButton
            text: "Scan library"
            onClicked: vidScanDialog.open()
        }
        Button {
            id: cleanButton
            anchors {
                left: scanButton.right
            }
            text: "Clean library"
            onClicked: {
                sendCommand('"VideoLibrary.Clean"', '{}')
            }
        }

        Button {
            id: update
            anchors { left: cleanButton.right }
            text: 'Update local library'
            onClicked: {
                requestData('"VideoLibrary.GetTVShows"',
                    '{"properties": ["title", "art", "thumbnail", "fanart"]}',
                    setSeriesModel)
            }
        }

        GridView {
            id: seriesTable
            anchors {
                top: scanButton.bottom; bottom: parent.bottom
                left: parent.left; right: parent.right
            }
            cellHeight: 200
            cellWidth: 110
            //model: 0
            //property var otherModel
            delegate: Column {
                //color: "transparent"
                height: parent.cellHeight
                width: parent.cellWidth
                Image {
                    id: img
                    //anchors { top: parent.top; left: parent.left }
                    source: seriesTable.model[index].art3
                    sourceSize.width: 100
                }
                Text {
                    id: txt
                    //anchors { top: img.bottom; left: parent.left }
                    text: seriesTable.model[index].title
                    width: 100
                    wrapMode: Text.Wrap
                }
            }
            highlight: Rectangle {color: "red"}
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var xval = parent.contentX + mouse.x
                    var yval = parent.contentY + mouse.y
                    seriesTable.currentIndex = seriesTable.indexAt(xval, yval)
                }
            }
        }
    }
}
