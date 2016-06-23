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

Action {
    id: backAction
    text: 'Back'
    tooltip: 'Go back to settings overview'
    iconName: 'go-previous'
    iconSource: 'icons/' + iconName + '.png'
    function checkforchanges() {}
    onTriggered: {
        if (checkforchanges()) {
            console.log('data')
            unsavedSettingsDialog.open()
        } else {
            settingsTabView.currentIndex = 0
        }
    }
}
