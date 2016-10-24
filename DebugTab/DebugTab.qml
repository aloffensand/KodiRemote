/*
 * Copyright © 2016 Aina Lea Offensand
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

import QtQuick 2.5
import QtQuick.Controls 1.3

Tab {
    id: debugTab
    title: 'Debug'

    Grid {
        anchors.fill: parent
        focus: true

        Button {
            text: 'Log current requests'
            onClicked: logCurrentRequests()
        }
        Button {
            text: 'Log key bindings'
            onClicked: {
                log('request', QKeySequence.keyBindings(StandardKey.Save))
                log('request', StandardKey.keyBindings(StandardKey.Save))
                log('request', StandardKey)
            }
        }

        // Just for developers.
        // Change the args to find information about any JsonRPC method.
        Button {
            text: 'Introspect'
            onClicked: {
                //var args = '{"filter": {"id": "Application.SetMute", "type": "method"}}'
                var requestid = "Player.Open"
                var type = "method"
                var args = '{"filter": {"id": "' + requestid
                args += '", "type": "' + type + '"}}'
                sendRequest('"JSONRPC.Introspect"', args, receiveIntrospect)
            }
            function receiveIntrospect(jsonObj) {
                log('debug', JSON.stringify(jsonObj))
            }
        }
    }
}
