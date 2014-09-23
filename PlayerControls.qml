import QtQuick 2.1
import QtQuick.Controls 1.1

Rectangle {
    id: playerControls
    color: 'transparent'
    property int playerid: parent.playerid
    property bool disabled: playerid < 0 ? true : false

    onDisabledChanged: {
        for( var i=0; i < children.length; i++) {
            children[i].enabled = ! disabled
        }
        //children.forEach(function(child) {
            //child.enabled = ! disabled
        //})
    }

    function setAudioStreamList(jsonObj) {
        var newList = []
        jsonObj.result.audiostreams.forEach(function(audio) {
            if(audio.language == "") {
                newList.push("Unknown")
            } else {
                newList.push(audio.language)
            }
        })
        if(audioStreamBox.model != newList) {
            audioStreamBox.model = newList
        }
    }

    function setCurrentAudioStream(jsonObj) {
        var lang = jsonObj.result.currentaudiostream.language
        if(lang == "")
            lang = "Unknown"
        audioStreamBox.currentIndex = audioStreamBox.find(lang)
    }

    function setSubtitleList(jsonObj) {
        var newList = ['-1: None']
        jsonObj.result.subtitles.forEach(function(sub) {
            var subStr = sub.index + ': '
            if(sub.language == '') {
                subStr += 'Unknown'
            } else {
                subStr += sub.language
            }
            newList.push(subStr)
        })
        if(subtitleBox.model != newList) {
            subtitleBox.model = newList
        }
    }

    function setCurrentSubtitle(jsonObj) {
        //var lang = jsonObj.result.currentsubtitle.language
        //if(lang == "")
            //lang = "Unknown"
            //subtitleBox.currentIndex = subtitleBox.find(lang)
        if (jsonObj.result.subtitleenabled) {
            var newIndex = jsonObj.result.currentsubtitle.index + 1
        } else {
            newIndex = 0
        }
        subtitleBox.currentIndex = newIndex
    }

    function setVideoLength(jsonObj) {
        var length = jsonObj.result.totaltime.seconds
        length += jsonObj.result.totaltime.minutes * 60
        length += jsonObj.result.totaltime.hours * 3600
        progressSlider.videoLength = length
        progressText.curLength = jsonObj.result.totaltime.hours
        progressText.curLength += ":" + jsonObj.result.totaltime.minutes + ":"
        progressText.curLength += jsonObj.result.totaltime.seconds
        hourBox.maximumValue = jsonObj.result.totaltime.hours
        minuteBox.alternateMax = jsonObj.result.totaltime.minutes
        secondBox.alternateMax = jsonObj.result.totaltime.seconds
    }

    function setVideoProgress(jsonObj) {
        progressSlider.value = jsonObj.result.percentage
    }

    function setVideoTime(jsonObj) {
        progressText.curTime = jsonObj.result.time.hours
        progressText.curTime += ":" + jsonObj.result.time.minutes + ":"
        progressText.curTime += jsonObj.result.time.seconds
    }

    Keys.onSpacePressed: playPauseAction.onTriggered()
    Keys.onEscapePressed: stopAction.onTriggered()

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
                text: 'Play/Pause'
                onClicked: {
                    sendCommand('"Player.PlayPause"', '{"playerid": ' + playerid + '}')
                }
            }
            Button {
                id: stopButton
                text: 'Stop'
                onClicked: {
                    sendCommand('"Player.Stop"', '{"playerid": ' + playerid + '}')
                }
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
                model: []
                onHoveredChanged: {
                    if (hovered) {
                        requestData('"Player.GetProperties"', '{"playerid": ' + playerid + ', "properties": ["audiostreams"]}', setAudioStreamList)
                        requestData('"Player.GetProperties"', '{"playerid": ' + playerid + ', "properties": ["currentaudiostream"]}', setCurrentAudioStream)
                    }
                }
                onActivated: {
                    sendCommand('"Player.SetAudioStream"', '{"playerid": ' + playerid + ', "stream": ' + index + '}')
                }
            }
            Text {
                text: 'Subtitles: '
            }
            ComboBox {
                id: subtitleBox
                model: []
                onHoveredChanged: {
                    if (hovered) {
                        requestData('"Player.GetProperties"', '{"playerid": ' + playerid + ', "properties": ["subtitles"]}', setSubtitleList)
                        requestData('"Player.GetProperties"', '{"playerid": ' + playerid + ', "properties": ["currentsubtitle", "subtitleenabled"]}', setCurrentSubtitle)
                    }
                }
                onActivated: {
                    var subIndex = model[index].split(':')[0]
                    if (subIndex != -1) {
                        console.log(subIndex + "ui")
                        sendCommand('"Player.SetSubtitle"', '{"playerid": ' + playerid + ', "subtitle": ' + subIndex + ', "enable": true}')
                    } else {
                        console.log(subIndex + "nri")
                        sendCommand('"Player.SetSubtitle"', '{"playerid": ' + playerid + ', "subtitle": "off"}')
                    }
                }
            }
        }

        Row {
            Text {
                text: 'time'
            }
        }
    }
}
