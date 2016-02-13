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
                var args = '{"filter": {"id": "Application.SetMute", "type": "method"}}'
                sendRequest('"JSONRPC.Introspect"', args, receiveIntrospect)
            }
            function receiveIntrospect(jsonObj) {
                log('debug', JSON.stringify(jsonObj.result))
            }
        }
    }
}
