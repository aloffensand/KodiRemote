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
