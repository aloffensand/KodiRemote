import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: playerControls
    color: 'transparent'
    height: childrenRect.height
    property int playerid: mainRec.playerid
    property string playertype: mainRec.playertype
    property bool playing: (playertype != 'none')

    property var updateMethods: []

    onPlayertypeChanged: {
        if (playertype == 'video') {
            audioStreamBox.enabled = true
            subtitleBox.enabled = true
            updateMethods = [
                updateNowPlayingText, updateVideoTimes,
                updateAudioStreamBox, updateSubtitleBox
            ]
        } else if (playertype != 'none') {
            updateMethods = [
                updateNowPlayingText, updateVideoTimes
            ]
        } else {
            audioStreamBox.enabled = false
            subtitleBox.enabled = false
            updateMethods = []
        }
    }

    function optionalTimer() {
        for (var i=0; i<updateMethods.length; i++) {
            updateMethods[i]()
        }
    }

    function fillWithZeroes(num) {
        if (num < 10) {
            return '0' + num
        } else {
            return num
        }
    }

    function arrays_equal(arr0, arr1) {
        if (arr0 == arr1) return true;
        if (arr0 == null || arr1 == null) return false;
        if (arr0.length != arr1.length) return false;
        for (var i = 0; i < arr0.length; i++) {
            if (arr0[i] !== arr1[i]) return false;
        }
        return true;
    }

    function requestPlayerProperties(properties, setterMethod) {
        var args = '{"playerid": ' + playerid +
                   ', "properties": [' + properties + ']}'
        requestData('"Player.GetProperties"', args, setterMethod)
    }

    function setAudioStreams(jsonObj) {
        var newList = []
        var streams = jsonObj.result.audiostreams
        var equal = (streams.length == audioStreamBox.model.length)
        for (var i = 0; i < streams.length; i++) {
            var streamString = streams[i].index + ': '
            if (streams[i].language == '') {
                streamString += 'Unknown'
            } else {
                streamString += streams[i].language
            }
            if (streams[i].name != '') {
                streamString += ' (' + streams[i].name + ')'
            }
            if (streamString != audioStreamBox.model[i]) {
                equal = false
            }
            newList.push(streamString)
        }
        if ( ! equal) {
            audioStreamBox.model = newList
        }
        var index = jsonObj.result.currentaudiostream.index
        audioStreamBox.currentIndex = index
    }

    function updateAudioStreamBox() {
        requestPlayerProperties('"audiostreams", "currentaudiostream"', setAudioStreams)
    }

    function setSubtitles(jsonObj) {
        var newList = ['-1: None']
        var subs = jsonObj.result.subtitles
        var equal = (subs.length == (subtitleBox.model.length - 1))
        for (var i=0; i < subs.length; i++) {
            var subStr = subs[i].index + ': '
            if (subs[i].language == '') {
                subStr += 'Unknown'
            } else {
                subStr += subs[i].language
            }
            if (subStr != subtitleBox.model[i + 1]) {
                equal = false
            }
            newList.push(subStr)
        }
        if ( ! equal) {
            subtitleBox.model = newList
        }

        var newIndex = subtitleBox.currentIndex
        if (jsonObj.result.subtitleenabled) {
            var newIndex = jsonObj.result.currentsubtitle.index + 1
        } else {
            newIndex = 0
        }
        subtitleBox.currentIndex = newIndex
    }

    function updateSubtitleBox() {
        var properties = '"subtitles", "currentsubtitle", "subtitleenabled"'
        requestPlayerProperties(properties, setSubtitles)
    }

    function setVideoTimes(jsonObj) {
        var minutes = fillWithZeroes(jsonObj.result.totaltime.minutes)
        var seconds = fillWithZeroes(jsonObj.result.totaltime.seconds)
        var length = jsonObj.result.totaltime.seconds
        length += jsonObj.result.totaltime.minutes * 60
        length += jsonObj.result.totaltime.hours * 3600
        //progressSlider.videoLength = length
        progressBar.videoLength = length
        progressText.curLength = jsonObj.result.totaltime.hours
        progressText.curLength += ":" + minutes
        progressText.curLength += ":" + seconds

        //progressSlider.value = jsonObj.result.percentage
        progressBar.value = jsonObj.result.percentage
        if ( ! leftTriangle.editing) {
            leftTriangle.x = ((progressBar.value/100) * progressBar.width) - leftTriangle.width
        }
        if ( ! rightTriangle.editing) {
            rightTriangle.x = ((progressBar.value/100) * progressBar.width)
        }

        var minutes = fillWithZeroes(jsonObj.result.time.minutes)
        var seconds = fillWithZeroes(jsonObj.result.time.seconds)
        progressText.curTime = jsonObj.result.time.hours
        progressText.curTime += ":" + minutes + ":"
        progressText.curTime += seconds
    }

    function updateVideoTimes() {
        var args = '"totaltime", "percentage", "time"'
        requestPlayerProperties(args, setVideoTimes)
    }

    function setNowPlayingText(jsonObj) {
        var newText = ' \n '
        //log('debug', jsonObj.result.item.type)
        if (jsonObj.result.item.type == 'episode') {
            var season = fillWithZeroes(jsonObj.result.item.season)
            var episode = fillWithZeroes(jsonObj.result.item.episode)
            newText = jsonObj.result.item.showtitle +
                      ' S' + season + 'E' + episode +
                      '\n' + jsonObj.result.item.title
        } else if (jsonObj.result.item.type == 'movie') {
            newText = jsonObj.result.item.title + '\n'
        } else if (jsonObj.result.item.type == 'song') {
            newText = jsonObj.result.item.artist + 
                      ' — ' + jsonObj.result.item.album +
                      '\n' + jsonObj.result.item.title
        } else {
            newText = jsonObj.result.item.title + '\n'
        }
        nowPlayingText.text = newText
    }

    function updateNowPlayingText() {
        var args = '{"playerid": ' + playerid +
                   ', "properties": [' +
                   '"title", ' +
                   '"episode", "season", "showtitle", "tvshowid", ' +
                   '"album", "artist"' +
                   ']}'
        requestData('"Player.GetItem"', args, setNowPlayingText)
    }

    PlayerControlAction {
        id: playPauseAction
        description: 'Play/Pause'
        iconName: 'media-playback-pause'
        shortcut: shortcut_playpause
        shortcut1: shortcut_playpause1
        onTriggered: {
            log('debug', 'Play/Pause...')
            sendCommand('"Player.PlayPause"', '{"playerid": ' + playerid + '}')
        }
    }
    SecondShortcutAction { mainAction: playPauseAction }
    PlayerControlAction {
        id: stopAction
        description: 'Stop'
        iconName: 'media-playback-stop'
        shortcut: shortcut_stop
        onTriggered: {
            log('debug', 'Stopping playback')
            sendCommand('"Player.Stop"', '{"playerid": ' + playerid + '}')
        }
    }
    SecondShortcutAction { mainAction: stopAction }
    PlayerControlAction {
        id: nextAction
        description: 'Next'
        iconName: 'go-next'
        shortcut: shortcut_next
        shortcut1: shortcut_next1
        onTriggered: {
            log('debug', 'Next item')
            var args = '{"playerid": ' + playerid +
                       ', "to": "next"}'
            sendCommand('"Player.GoTo"', args)
        }
    }
    SecondShortcutAction { mainAction: nextAction }
    PlayerControlAction {
        id: previousAction
        description: 'Previous'
        iconName: 'go-previous'
        shortcut: shortcut_previous
        shortcut1: shortcut_previous1
        onTriggered: {
            log('debug', 'Previous item')
            var args = '{"playerid": ' + playerid +
                       ', "to": "previous"}'
            sendCommand('"Player.GoTo"', args)
        }
    }
    SecondShortcutAction { mainAction: previousAction }
    PlayerControlAction {
        id: showOsdAction
        text: 'Show OSD'
        description: 'Show OnScreenDisplay for the current player'
        shortcut: shortcut_osd
        shortcut1: shortcut_osd1
        onTriggered: {
            log('debug', 'Showing OSD')
            sendCommand('"Input.ShowOSD"', '{}')
        }
    }
    SecondShortcutAction { mainAction: showOsdAction }
    PlayerControlAction {
        id: playpauseselectAction
        description: 'If there is an active player, this will act as PlayPause; else, it will be Select.'
        shortcut: shortcut_playpauseselect
        shortcut1: shortcut_playpauseselect1
        onTriggered: {
            if (playing) {
                log('debug', 'Sending playpause')
                sendCommand('"Player.PlayPause"', '{"playerid": ' + playerid + '}')
            } else {
                log('debug', 'Selecting item')
                sendCommand('"Input.Select"', '{}')
            }
        }
    }
    SecondShortcutAction { mainAction: playpauseselectAction }

    Column {
        anchors.fill: parent
        spacing: 7

        Row {
            Label {
                id: nowPlayingText
                text: ' \n '
            }
        }

        Row {
            Button { action: playPauseAction }
            Button { action: stopAction }
            Text { text: '     ' }
            Button { action: previousAction }
            Button { action: nextAction }
            Text { text: '      ' }
            Button { action: showOsdAction }
        }

        Grid {
            columns: 2
            verticalItemAlignment: Grid.AlignVCenter
            Label {
                text: 'Audio: '
            }
            ComboBox {
                id: audioStreamBox
                width: 200
                model: []
                onHoveredChanged: {
                    if (hovered) {
                        updateAudioStreamBox()
                    }
                }
                onActivated: {
                    var streamIndex = model[index].split(':')[0]
                    var args = '{"playerid": ' + playerid +
                               ', "stream": ' + streamIndex + '}'
                    sendCommand('"Player.SetAudioStream"', args)
                }
            }
            Label {
                text: 'Subtitles:   '
            }
            ComboBox {
                id: subtitleBox
                width: 200
                model: []
                onHoveredChanged: {
                    if (hovered) {
                        updateSubtitleBox()
                    }
                }
                onActivated: {
                    var subIndex = model[index].split(':')[0]
                    if (subIndex != -1) {
                        var args = '{"playerid": ' + playerid +
                                   ', "subtitle": ' + subIndex +
                                   ', "enable": true}'
                    } else {
                        args = '{"playerid": ' + playerid +
                               ', "subtitle": "off"}'
                    }
                    sendCommand('"Player.SetSubtitle"', args)
                }
            }
        }

        RowLayout {
            width: parent.width
            spacing: 7

            Rectangle {
                id: progressRect
                Layout.fillWidth: true
                height: progressBar.height + leftTriangle.height + jumpToText.height
                color: "transparent"

                // triangles are split
                property bool split: false
                // is split and both triangles are set
                property bool looping: false
                property real jumpFrom: 0
                property real jumpTo: 0

                // FIXME: different colours when it's inactive
                ProgressBar {
                    id: progressBar
                    width: parent.width
                    minimumValue: 0
                    maximumValue: 100
                    property int currentVideoTime: 0
                    property int videoLength: 45*60  // in seconds

                    function getTime (percentage) {
                        var total = percentage * videoLength / 100
                        var hours = Math.floor(total / 3600)
                        var minutes = Math.floor( (total / 60) % 60)
                        var seconds = Math.floor(total % 60)
                        return [hours, minutes, seconds]
                    }
                }
                function getJumpTextPosition (left, textWidth) {
                    var pos = 0
                    var leftBoundary = 0
                    var rightBoundary = progressBar.width - textWidth
                    if (left) {
                        pos = leftTriangle.x - textWidth
                    } else if (split) {
                        pos = rightTriangle.x
                    } else {
                        pos = rightTriangle.x - textWidth / 2
                    }
                    pos = Math.max(pos, leftBoundary)
                    pos = Math.min(pos, rightBoundary)
                    return pos
                }

                Triangle {
                    id: leftTriangle
                    anchors.top: progressBar.bottom
                    anchors.topMargin: 2
                    // set to true so the triangle doesn't follow the current time
                    property bool editing: false
                    height: 15
                    width: 10
                    color: systemPalette.base
                    borderColor: systemPalette.text
                    point1: width + ",0"
                }
                Triangle {
                    id: rightTriangle
                    anchors.top: progressBar.bottom
                    anchors.topMargin: leftTriangle.anchors.topMargin
                    // set to true so it doesn't follow the current time
                    property bool editing: false
                    height: leftTriangle.height
                    width: leftTriangle.width
                    color: systemPalette.base
                    borderColor: systemPalette.text
                    point1: "0,0"
                }
                TextField {
                    id: jumpFromText
                    anchors.top: leftTriangle.bottom
                    anchors.topMargin: 3
                    x: parent.getJumpTextPosition(true, width)
                    visible: parent.split
                    text: '0:00:00'
                    inputMask: '9:99:99'
                    property var re: /[0-9]:[0-5][0-9]:[0-5][0-9]/
                    validator: RegExpValidator { regExp: jumpToText.re }
                }
                TextField {
                    id: jumpToText
                    anchors.top: rightTriangle.bottom
                    anchors.topMargin: jumpFromText.anchors.topMargin
                    x: parent.getJumpTextPosition(false, width)
                    text: '0:00:00'
                    inputMask: '9:99:99'
                    property var re: /[0-9]:[0-5][0-9]:[0-5][0-9]/
                    validator: RegExpValidator { regExp: jumpToText.re }
                }

                MouseArea {
                    id: progressBarMouseArea
                    //anchors.fill: parent
                    x: 0; y:0
                    height: leftTriangle.y + leftTriangle.height
                    width: progressBar.width
                    enabled: playing
                    hoverEnabled: true

                    onEntered: updateVideoTimes()
                    onPositionChanged: {
                        var newTime = progressBar.getTime(mouseX/width*100)
                        hoverText.text = newTime[0] + ":" +
                                         fillWithZeroes(newTime[1]) + ":" +
                                         fillWithZeroes(newTime[2])
                    }
                    onClicked: {
                        var newTime = progressBar.getTime(mouse.x/width*100)
                        var args = '{"playerid": ' + playerid +
                                   ', "value": ' + 
                                   '{ "hours": ' + newTime[0] +
                                   ', "minutes": ' + newTime[1] +
                                   ', "seconds": ' + newTime[2] + '}}'
                        sendCommand('"Player.Seek"', args)
                        updateVideoTimes()
                    }
                }

                Rectangle {
                    id: hoverRect
                    height: hoverText.implicitHeight + 4
                    width: Math.max(50, hoverText.implicitWidth + 4)
                    visible: progressBarMouseArea.containsMouse
                    x: progressBarMouseArea.mouseX
                    y: -10
                    color: systemPalette.alternateBase
                    border.color: "black"
                    border.width: 1
                    radius: 2
                    Label { id: hoverText; text: "text"; anchors.centerIn: parent }
                }
            }
            Rectangle {
                color: "transparent"
                height: childrenRect.height
                width: childrenRect.width
                Layout.alignment: Qt.AlignTop

                Label {
                    id: progressText
                    y: (progressBar.height-progressText.height) / 2 
                    property string curTime: '0:00:00'
                    property string curLength: '0:00:00'
                    text: curTime + ' / ' + curLength
                }
                // Buttons: jump, start loop, end loop, cancel
                Button {
                    id: jumpButton
                    y: progressBar.height + 8
                    text: 'Jump'
                    onClicked: {
                        var newTime = jumpToText.text.split(':')
                        // parseInt to strip leading zeroes, kodi can't handle those …
                        var args = '{"playerid": ' + playerid +
                                   ', "value": ' + 
                                   '{ "hours": ' + parseInt(newTime[0], 10) +
                                   ', "minutes": ' + parseInt(newTime[1], 10) +
                                   ', "seconds": ' + parseInt(newTime[2], 10) + '}}'
                        sendCommand('"Player.Seek"', args)
                    }
                }
                //Button {
                    //id: loopButton
                    //anchors.left: jumpButton.right
                    //anchors.top: jumpButton.top
                    //text: !progressRect.split ? 'Set startpoint' :
                          //!progressRect.looping ? 'Set endpoint' :
                          //'Cancel loop'
                    //onClicked: {
                        //if ( ! progressRect.split) {
                            //leftTriangle.editing = true
                            //progressRect.split = true
                        //} else if ( ! progressRect.looping) {
                            //rightTriangle.editing = true
                            //progressRect.looping = true
                        //} else {
                            //leftTriangle.editing = false
                            //rightTriangle.editing = false
                            //progressRect.split = false
                            //progressRect.looping = false
                        //}
                    //}
                //}
            }
        }
    }
}
