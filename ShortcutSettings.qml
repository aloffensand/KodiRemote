import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

GridLayout {
    id: shortcutSettings
    columns: 3

    property var shortcutTextFields: [
        leftText, leftText1, rightText, rightText1,
        upText, upText1, downText, downText1,
        backText, backText1, selectText, selectText1,
        contextText, contextText1, infoText, infoText1,
        homeText, homeText1, enterTextText, enterTextText1,
        settingsText, settingsText1,
        playpauseText, playpauseText1, stopText, stopText1,
        nextText, nextText1, previousText, previousText1,
        osdText, osdText1,
        playpauseselectText, playpauseselectText1
    ]
    property var newShortcuts: {'shortcut': ['list of', 'arrayIndexes']}
    property int invalids: 0

    function dictContainsKey(dict, key) {
        return (Object.keys(dict).indexOf(key) != -1 && dict[key] != null)
    }

    function changeShortcut(text, oldShortcut, arrayIndex) {
        testAction.shortcut = text
        var newShortcut = testAction.shortcut
        var item = shortcutTextFields[arrayIndex]
        // Test if the new shortcut is valid first. This is important for the
        // case that the shortcut is changed from e.g. "" to "invalid"
        if (newShortcut == '' && text != '') {
            item.valid = false
            invalids += 1
        // If the shortcut was invalid before, make it valid and decrease the
        // validity counter.
        } else if (item.valid == false) {
            item.valid = true
            invalids -= 1
        }
        // Don't do anything else if it wasn't changed
        if (newShortcut == oldShortcut) {
            return
        }
        // Remove the old shortcut (if existant)
        if (oldShortcut != '') {
            removeShortcut(oldShortcut, arrayIndex)
        }
        if (newShortcut != '') {
            addShortcut(newShortcut, arrayIndex)
        }
        item.oldShortcut = newShortcut
    }

    function removeShortcut(shortcut, arrayIndex) {
        var item = shortcutTextFields[arrayIndex]
        if ( ! dictContainsKey(newShortcuts, shortcut) ) {
            log('notice', 'Attempted to remove nonexistant shortcut.')
        } else {
            var itemList = newShortcuts[shortcut]
            // Not much to do if it was the only shortcut
            if (itemList.length == 1 && itemList[0] == arrayIndex) {
                newShortcuts[shortcut] = null
            } else if (itemList.length == 1) {
                log('notice', 'Attempted to remove nonexistant item.')
            // more than one item in the list == duplicate shortcuts
            } else {
                var newList = []
                for (var i=0; i < itemList.length; i++) {
                    if (itemList[i] != arrayIndex) {
                        newList.push(itemList[i])
                    }
                }
                item.unique = true
                invalids -= 1
                if (newList.length == 1) {
                    shortcutTextFields[newList[0]].unique = true
                }
                newShortcuts[shortcut] = newList
            }
        }
    }

    function addShortcut(shortcut, arrayIndex) {
        var item = shortcutTextFields[arrayIndex]
        if ( ! dictContainsKey(newShortcuts, shortcut) ) {
            newShortcuts[shortcut] = [arrayIndex]
        } else {
            // If there are >=2 elements in the list, those elements must
            // have been marked as duplicates before
            if (newShortcuts[shortcut].length == 1) {
                shortcutTextFields[newShortcuts[shortcut][0]].unique = false
            }
            item.unique = false
            invalids += 1
            newShortcuts[shortcut].push(arrayIndex)
        }
    }

    function updateAllValid() {
    }

    Component.onCompleted: {
        newShortcuts = {}
        for (var i=0; i < shortcutTextFields.length; i++) {
            var item = shortcutTextFields[i]
            item.arrayIndex = i
            changeShortcut(item.shortcut, '', i)
        }
    }

    Action { id: testAction }

    ApplyAction {
        id: applyAction
    }

    BackAction { id: backAction }

    Label { text: 'Left: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: leftText; target: "shortcut_left" }
    ShortcutTextField { id: leftText1; target: "shortcut_left1" }
    Label { text: 'Right: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: rightText; target: "shortcut_right" }
    ShortcutTextField { id: rightText1; target: "shortcut_right1" }
    Label { text: 'Up: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: upText; target: "shortcut_up" }
    ShortcutTextField { id: upText1; target: "shortcut_up1" }
    Label { text: 'Down: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: downText; target: "shortcut_down" }
    ShortcutTextField { id: downText1; target: "shortcut_down1" }
    Label { text: 'Back: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: backText; target: "shortcut_back" }
    ShortcutTextField { id: backText1; target: "shortcut_back1" }
    Label { text: 'Select: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: selectText; target: "shortcut_select" }
    ShortcutTextField { id: selectText1; target: "shortcut_select1" }
    Label { text: 'Context Menu: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: contextText; target: "shortcut_context" }
    ShortcutTextField { id: contextText1; target: "shortcut_context1" }
    Label { text: 'Info: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: infoText; target: "shortcut_info" }
    ShortcutTextField { id: infoText1; target: "shortcut_info1" }
    Label { text: 'Home: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: homeText; target: "shortcut_home" }
    ShortcutTextField { id: homeText1; target: "shortcut_home1" }
    Label { text: 'Enter Text: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: enterTextText; target: "shortcut_enterText" }
    ShortcutTextField { id: enterTextText1; target: "shortcut_enterText1" }
    Label { text: 'Settings: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: settingsText; target: "shortcut_settings" }
    ShortcutTextField { id: settingsText1; target: "shortcut_settings1" }
    Label { text: 'PlayPause: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: playpauseText; target: "shortcut_playpause" }
    ShortcutTextField { id: playpauseText1; target: "shortcut_playpause1" }
    Label { text: 'Stop: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: stopText; target: "shortcut_stop" }
    ShortcutTextField { id: stopText1; target: "shortcut_stop1" }
    Label { text: 'Next: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: nextText; target: "shortcut_next" }
    ShortcutTextField { id: nextText1; target: "shortcut_next1" }
    Label { text: 'Previous: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: previousText; target: "shortcut_previous" }
    ShortcutTextField { id: previousText1; target: "shortcut_previous1" }
    Label { text: 'Show OSD: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: osdText; target: "shortcut_osd" }
    ShortcutTextField { id: osdText1; target: "shortcut_osd1" }
    Label { text: 'PlayPause / Select: '; Layout.alignment: labelAlignment }
    ShortcutTextField { id: playpauseselectText; target: "shortcut_playpauseselect" }
    ShortcutTextField { id: playpauseselectText1; target: "shortcut_playpauseselect1" }

    Text { text: ''; Layout.columnSpan: 2 }
    Button {
        id: applyButton
        Layout.alignment: Qt.AlignRight
        text: applyAction.text
        iconName: applyAction.iconName
        iconSource: applyAction.iconSource
        tooltip: applyAction.tooltip
        states: State {
            name: "invalids"; when: (invalids > 0)
            PropertyChanges {
                target: applyButton
                iconName: 'dialog-warning'
                tooltip: 'Apply valid changes, invalid shortcuts will be unset.'
            }
        }
    }
}
