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
import QtQuick.Dialogs 1.1

Tab {
    id: videoTab
    title: "Videos"
    Rectangle {
        anchors {
            fill: parent
            margins: margins
        }
        color: "transparent"
        property var allShowsModel: []

        function parse_image_url(raw_url) {
            console.log(raw_url)
            var new_url = raw_url.slice(8, raw_url.length-1)
            new_url = httpUrl + '/image/image://' + encodeURIComponent(new_url)
            return new_url
        }

        function setSeriesModel(jsonObj) {
            var newModel = []
            jsonObj.result.tvshows.forEach(function(show) {
                var banner = parse_image_url(show.art.banner)
                //var thumb = parse_image_url(show.art.thumb)
                var poster = parse_image_url(show.art.poster)
                var fanart0 = parse_image_url(show.art.fanart)
                var fanart1 = parse_image_url(show.fanart)
                var thumbnail = parse_image_url(show.thumbnail)

                newModel.push({title: show.title,
                               banner: banner,
                               //thumb: thumb,
                               poster: poster,
                               fanart0: fanart0,
                               fanart1: fanart1,
                               thumbnail: thumbnail
                })
            })
            console.log(newModel[0].title)
            console.log(newModel[0].art)
            //seriesTable.otherModel = newModel
            //seriesTable.model = newModel.length
            //seriesTable.model = newModel
            allShowsModel = newModel
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

        StackView {
            initialItem: allShowsTable
            anchors {
                top: scanButton.bottom; bottom: parent.bottom
                left: parent.left; right: parent.right
            }

        }

        Component {
            id: allShowsTable
            GridView {
                id: seriesTable
                //anchors {
                    //top: scanButton.bottom; bottom: parent.bottom
                    //left: parent.left; right: parent.right
                //}
                cellHeight: 200
                cellWidth: 110
                model: allShowsModel
                //model: 0
                //property var otherModel
                delegate: Column {
                    //color: "transparent"
                    height: parent.cellHeight
                    width: parent.cellWidth
                    Image {
                        id: img
                        //anchors { top: parent.top; left: parent.left }
                        //source: imageUrl + encodeURIComponent(seriesTable.model[index].art3)
                        source: seriesTable.model[index].poster
                        sourceSize.width: 100
                    }
                    Label {
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
}
