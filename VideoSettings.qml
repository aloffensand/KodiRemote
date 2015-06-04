import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

GridLayout {
    columns: 2

    ApplyAction {
        id: applyAction
        onTriggered: {
            defaultAudio = defaultAudioText.text
            defaultSubtitles = defaultSubtitlesText.text
        }
    }

    Label { text: 'Default Audio: ' }
    TextField {
        // TODO: Allow regular expressions or comma separated values
        id: defaultAudioText
        text: defaultAudio
    }
    Label { text: 'Default Subtitles: ' }
    TextField {
        // TODO: Allow regular expressions or comma separated values
        id: defaultSubtitlesText
        text: defaultSubtitles
    }
    // TODO: Add exceptions (at least for subtitles)

    Button { id: applyButton; action: applyAction }
}
