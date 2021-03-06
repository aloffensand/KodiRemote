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
