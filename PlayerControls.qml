import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: playerControls
    color: 'transparent'
    property int playerid: parent.playerid
    property string playertype: parent.playertype
    property bool playing: (playertype != 'none')

    onPlayertypeChanged: {
        if (playertype == 'video') {
            audioStreamBox.enabled = true
            subtitleBox.enabled = true
        } else {
            audioStreamBox.enabled = false
            subtitleBox.enabled = false
        }
    }

    function fillWithZeroes(num) {
        if (num < 10) {
            return '0' + num
        } else {
            return num
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
        var minutes = fillWithZeroes(jsonObj.result.totaltime.minutes)
        var seconds = fillWithZeroes(jsonObj.result.totaltime.seconds)
        var length = jsonObj.result.totaltime.seconds
        length += jsonObj.result.totaltime.minutes * 60
        length += jsonObj.result.totaltime.hours * 3600
        progressSlider.videoLength = length
        progressText.curLength = jsonObj.result.totaltime.hours
        progressText.curLength += ":" + minutes
        progressText.curLength += ":" + seconds
    }

    function setVideoProgress(jsonObj) {
        progressSlider.value = jsonObj.result.percentage
    }

    function setVideoTime(jsonObj) {
        var minutes = fillWithZeroes(jsonObj.result.time.minutes)
        var seconds = fillWithZeroes(jsonObj.result.time.seconds)
        progressText.curTime = jsonObj.result.time.hours
        progressText.curTime += ":" + minutes + ":"
        progressText.curTime += seconds
    }

    function updateVideoTimes() {
        requestPlayerProperties('"totaltime"', setVideoLength)
        requestPlayerProperties('"percentage"', setVideoProgress)
        requestPlayerProperties('"time"', setVideoTime)
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

    Timer {
        id: updateTimer
        interval: 2000
        repeat: true
        triggeredOnStart: true
        running: playing
        onTriggered: {
            updateNowPlayingText()
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
        shortcut: 'Space'
        enabled: playing
        onTriggered: {
            log('debug', 'Play/Pause...')
            sendCommand('"Player.PlayPause"', '{"playerid": ' + playerid + '}')
        }
    }

    Action {
        id: stopAction
        text: 'Stop'
        tooltip: 'Stop playback (Escape)'
        shortcut: 'Escape'
        enabled: playing
        onTriggered: {
            log('debug', 'Stopping playback')
            sendCommand('"Player.Stop"', '{"playerid": ' + playerid + '}')
        }
    }

    Action {
        id: nextAction
        text: '&Next'
        tooltip: 'Next item (N)'
        shortcut: 'n'
        enabled: playing
        onTriggered: {
            log('debug', 'Next item')
            var args = '{"playerid": ' + playerid +
                       ', "to": "next"}'
            sendCommand('"Player.GoTo"', args)
        }
    }
    Action {
        id: previousAction
        text: '&Previous'
        tooltip: 'Previous item (P)'
        shortcut: 'p'
        enabled: playing
        onTriggered: {
            log('debug', 'Previous item')
            var args = '{"playerid": ' + playerid +
                       ', "to": "previous"}'
            sendCommand('"Player.GoTo"', args)
        }
    }

    Column {
        anchors.fill: parent
        spacing: 7

        Row {
            Text {
                id: nowPlayingText
                text: ' \n '
            }
        }

        Row {
            Button {
                id: playPauseButton
                action: playPauseAction
            }
            Button {
                id: stopButton
                action: stopAction
            }
            Text { text: '     ' }
            Button {
                id: previousButton
                action: previousAction
            }
            Button {
                id: nextButton
                action: nextAction
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
                enabled: playing
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
