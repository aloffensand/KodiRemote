import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: playerControls
    color: 'transparent'
    property int playerid: parent.playerid
    property string playertype: parent.playertype

    onPlayertypeChanged: {
        var enabled = (playertype != 'none')
        for( var i=0; i < children.length; i++) {
            children[i].enabled = enabled
        }
        updateTimer.running = enabled

        if (enabled && playertype != 'video') {
            console.log(playertype)
            audioStreamBox.enabled = false
            subtitleBox.enabled = false
        }
    }

    function requestPlayerProperties(properties, setterMethod) {
        var args = '{"playerid": ' + playerid +
                   ', "properties": [' + properties + ']}'
        requestData('"Player.GetProperties"', args, setterMethod)
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

    function setAudioStreamList(jsonObj) {
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
    }

    function setCurrentAudioStream(jsonObj) {
        var index = jsonObj.result.currentaudiostream.index
        audioStreamBox.currentIndex = index
    }

    function updateAudioStreamBox() {
        requestPlayerProperties('"audiostreams"', setAudioStreamList)
        requestPlayerProperties('"currentaudiostream"', setCurrentAudioStream)
    }

    function setSubtitleList(jsonObj) {
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
    }

    function setCurrentSubtitle(jsonObj) {
        var newIndex = subtitleBox.currentIndex
        if (jsonObj.result.subtitleenabled) {
            var newIndex = jsonObj.result.currentsubtitle.index + 1
        } else {
            newIndex = 0
        }
        subtitleBox.currentIndex = newIndex
    }

    function updateSubtitleBox() {
        requestPlayerProperties('"subtitles"', setSubtitleList)
        var properties = '"currentsubtitle", "subtitleenabled"'
        requestPlayerProperties(properties, setCurrentSubtitle)
    }

    function setVideoLength(jsonObj) {
        var length = jsonObj.result.totaltime.seconds
        length += jsonObj.result.totaltime.minutes * 60
        length += jsonObj.result.totaltime.hours * 3600
        progressSlider.videoLength = length
        progressText.curLength = jsonObj.result.totaltime.hours
        progressText.curLength += ":" + jsonObj.result.totaltime.minutes + ":"
        progressText.curLength += jsonObj.result.totaltime.seconds
    }

    function setVideoProgress(jsonObj) {
        progressSlider.value = jsonObj.result.percentage
    }

    function setVideoTime(jsonObj) {
        progressText.curTime = jsonObj.result.time.hours
        progressText.curTime += ":" + jsonObj.result.time.minutes + ":"
        progressText.curTime += jsonObj.result.time.seconds
    }

    function updateVideoTimes() {
        requestPlayerProperties('"totaltime"', setVideoLength)
        requestPlayerProperties('"percentage"', setVideoProgress)
        requestPlayerProperties('"time"', setVideoTime)
    }

    Keys.onSpacePressed: playPauseAction.onTriggered()
    Keys.onEscapePressed: stopAction.onTriggered()

    Timer {
        id: updateTimer
        interval: 2000
        repeat: true
        running: ! parent.disabled
        triggeredOnStart: true
        onTriggered: {
            updateVideoTimes()
            if (playertype == 'video') {
                updateAudioStreamBox()
                updateSubtitleBox()
            }
        }
    }

    Action {
        id: playPauseAction
        text: 'Play/Pause'
        tooltip: 'Play/Pause (Space)'
        onTriggered: {
            console.log('Play/Pause...')
            sendCommand('"Player.PlayPause"', '{"playerid": ' + playerid + '}')
        }
    }

    Action {
        id: stopAction
        text: 'Stop'
        tooltip: 'Stop playback (Escape)'
        onTriggered: {
            console.log('Stopping playback')
            sendCommand('"Player.Stop"', '{"playerid": ' + playerid + '}')
        }
    }

    Column {
        anchors.fill: parent
        spacing: 7

        Row {
            Button {
                id: playPauseButton
                action: playPauseAction
            }
            Button {
                id: stopButton
                action: stopAction
            }
        }

        Grid {
            columns: 2
            verticalItemAlignment: Grid.AlignVCenter
            Text {
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
            Text {
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

            OtherSlider {
                id: progressSlider
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 100
                style: OtherSliderStyle {}
                property int currentVideoTime: 0
                property int videoLength: 45*60  // in seconds

                function getTime (percentage) {
                    var total = percentage * videoLength / 100
                    var hours = Math.floor(total / 3600)
                    var minutes = Math.floor( (total / 60) % 60)
                    var seconds = Math.floor(total % 60)
                    return [hours, minutes, seconds]
                }

                onPressedChanged: {
                    if ( ! pressed) {
                        var newTime = getTime(value)
                        var args = '{"playerid": ' + playerid +
                                   ', "value": ' + 
                                   '{ "hours": ' + newTime[0] +
                                   ', "minutes": ' + newTime[1] +
                                   ', "seconds": ' + newTime[2] + '}}'
                        sendCommand('"Player.Seek"', args)
                    }
                }

                Rectangle {
                    id: hoverRect
                    height: hoverText.implicitHeight
                    width: Math.max(50, hoverText.implicitWidth)
                    visible: progressSlider.hovered
                    x: progressSlider.hoveredPosition
                    y: -10
                    color: "red"
                    Text { id: hoverText; text: "text" }
                }

                onHoveredChanged: {
                    if(hovered) {
                        updateVideoTimes()
                    }
                }

                onHoveredValueChanged: {
                    var newTime = progressSlider.getTime(hoveredValue)
                    hoverText.text = newTime[0] + ":" +
                                     newTime[1] + ":" +
                                     newTime[2]
                }
            }

            Text {
                id: progressText
                property string curTime: '0:00:00'
                property string curLength: '0:00:00'
                text: curTime + ' / ' + curLength
            }
        }
    }
}
