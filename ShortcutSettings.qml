import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

ScrollView {
    id: scrollView
    anchors.fill: parent
    focus: true

    Rectangle {
        id: frameRect
        width: shortcutSettings.width + shortcutSettings.x*2
        height: shortcutSettings.height + shortcutSettings.y*2
        color: "transparent"

GridLayout {
    id: shortcutSettings
    columns: 3
    property int margins: 10
    x: margins
    y: margins
    // If the window is bigger than the GridLayout, use all of the available
    // space; otherwise, use the GridLayout's inherent size.
    width: Math.max(implicitWidth, scrollView.viewport.width - margins*2)
    height: Math.max(implicitHeight, scrollView.viewport.height - margins*2)
    //anchors.fill: parent
    //anchors.centerIn: parent
    //anchors.margins: parent.height / 20
    //anchors.margins: 10
    //anchors {
        //left: parent.left; top: parent.top
        //margins: shortcutSettings.margins
    //}

    // A list of all the ShortcutTextFields
    property var shortcutItems: [
        leftText, leftText1, rightText, rightText1, upText, upText1,
        downText, downText1, backText, backText1, selectText, selectText1,
        contextText, contextText1, infoText, infoText1, homeText, homeText1,
        enterTextText, enterTextText1, settingsText, settingsText1,
        playpauseText, playpauseText1, stopText, stopText1,
        nextText, nextText1, previousText, previousText1, osdText, osdText1,
        playpauseselectText, playpauseselectText1
    ]
    property var invalidShortcuts: {'none': ''}
    property var addedShortcuts: {'none': ''}
    property var duplicateShortcuts: {'none': []}
    property var validShortcuts: {'none': ''}
    property bool allValid: true

    Action { id: testAction }
    
    function dictContainsKey(dict, key) {
        return Object.keys(dict).indexOf(key) != -1
    }

    // Save valid shortcuts, set invalid shortcuts to the empty string
    // (to prevent duplicates if e.g. you have left=l and right=r and the user
    // than attempts to set left=invalid and right=l. If left retained its
    // former shortcut, you would now have two shortcuts for the key l.
    function saveShortcuts() {
        var target = ''
        for (target in validShortcuts) {
            frame[target] = validShortcuts[target]
        }
        for (target in invalidShortcuts) {
            frame[target] = ''
        }
        for (var shortcut in duplicateShortcuts) {
            var targets = duplicateShortcuts[shortcut]
            for (var i=0; i < targets.length; i++) {
                frame[targets[i]] = ''
            }
        }
        // Make sure the textfields show the correct shortcuts
        discardChanges()
    }

    function addShortcut(target, shortcut) {
        var valid = true
        // Empty shorcuts are valid and may have duplicates, therefore don't
        // have to be tested
        if (shortcut == '') {
            validShortcuts[target] = shortcut
            return
        }
        // Test if QML recognises the shortcut
        testAction.shortcut = shortcut
        if (testAction.shortcut == '') {
            valid = false
            allValid = false
            //invalidShortcuts.push([target, shortcut])
            invalidShortcuts[target] = shortcut
        } else {
            // Turn into QML's representation to detect duplicates more
            // effectively
            shortcut = testAction.shortcut
        }
        // Check for duplicates
        if (dictContainsKey(shortcutSettings.addedShortcuts, shortcut)) {
            valid = false
            allValid = false
            var duplicateTarget = addedShortcuts[shortcut]
            if (dictContainsKey(duplicateShortcuts, shortcut)) {
                duplicateShortcuts[shortcut].push(target)
            } else {
                duplicateShortcuts[shortcut] = [target, duplicateTarget]
            }
        }
        addedShortcuts[shortcut] = target
        if (valid) {
            validShortcuts[target] = shortcut
        }
    }

    // Set text back to the current shortcut
    function resetShortcutText(shortcutItem) {
        shortcutItem.text = frame[shortcutItem.shortcut]
    }

    // Set all texts to their current shortcut
    function discardChanges() {
        for (var i=0; i < shortcutItems.length; i++) {
            resetShortcutText(shortcutItems[i])
        }
    }


    // Test if changes are valid. If they are, save them; otherwise, ask the
    // user what to do.
    function apply() {
        allValid = true
        addedShortcuts = {}
        duplicateShortcuts = {}
        validShortcuts = {}
        invalidShortcuts = {}

        for (var i=0; i < shortcutItems.length; i++) {
            addShortcut(shortcutItems[i].shortcut, shortcutItems[i].text)
        }

        if (allValid) {
            saveShortcuts()
            log('debug', 'Saved shortcut settings')
        } else {
            var warningString = ''
            if (Object.keys(invalidShortcuts).length > 0) {
                warningString += 'Invalid shortcuts:'
                for (var target in invalidShortcuts) {
                    var shortcut = invalidShortcuts[target]
                    warningString += '\n\t' + target + ': ' + shortcut
                }
            }
            if (Object.keys(duplicateShortcuts).length > 0) {
                warningString += '\nDuplicate shortcuts:'
                for (var key in duplicateShortcuts) {
                    warningString += '\n\t' + key + ': '
                    warningString += duplicateShortcuts[key]
                }
            }
            warningDialog.warningString = warningString
            warningDialog.open()
            log('warning', warningString)
            //FIXME: colour the invalid shortcuts
        }
    }

    function checkForChanges() {
        var changed = false
        for (var i=0; i < shortcutItems.length; i++) {
            testAction.shortcut = shortcutItems[i].text
            if (testAction.shortcut != frame[shortcutItems[i].shortcut]) {
                changed = true
            }
        }
        return changed
    }

    ApplyAction {
        id: applyAction
        onTriggered: shortcutSettings.apply()
    }

    BackAction {
        id: backAction
        function checkforchanges() {
            return shortcutSettings.checkForChanges()
        }
    }

    MessageDialog {
        id: warningDialog
        title: 'Apply Settings - KodiRemote'
        property string warningString: ''
        text: 'Invalid or duplicate shortcuts detected:\n\n' +
              warningString +
              '\n\nWhat do you want to do?'
        detailedText: ''
        // FIXME: would be neat if the buttons had the labels
        //        "Apply valid shortcuts", "Discard changes" and "Cancel"
        //        or "Edit" or something like that
        standardButtons: StandardButton.Apply | StandardButton.Discard | StandardButton.Cancel
        onApply: {
            shortcutSettings.saveShortcuts()
            log('debug', 'Saved valid shortcuts.')
        }
        onDiscard: {
            shortcutSettings.discardChanges()
        }
    }

    MessageDialog {
        id: unsavedSettingsDialog
        title: 'Apply Settings - KodiRemote'
        text: 'The Settings of the current module have changed. ' +
              'Do you want to apply the changes or discard them?'
        standardButtons: StandardButton.Apply | StandardButton.Discard | StandardButton.Cancel
        onApply: applyAction.trigger()
        onDiscard: {
            shortcutSettings.discardChanges()
            settingsTabView.currentIndex = 0
        }
    }

    // TODO: Add a way to find out which string generates the desired shortcut

    Label { text: 'Left' }
    ShortcutTextField { id: leftText; shortcut: "shortcut_left" }
    ShortcutTextField { id: leftText1; shortcut: "shortcut_left1" }
    Label { text: 'Right' }
    ShortcutTextField { id: rightText; shortcut: "shortcut_right" }
    ShortcutTextField { id: rightText1; shortcut: "shortcut_right1" }
    Label { text: 'Up' }
    ShortcutTextField { id: upText; shortcut: "shortcut_up" }
    ShortcutTextField { id: upText1; shortcut: "shortcut_up1" }
    Label { text: 'Down' }
    ShortcutTextField { id: downText; shortcut: "shortcut_down" }
    ShortcutTextField { id: downText1; shortcut: "shortcut_down1" }
    Label { text: 'Back' }
    ShortcutTextField { id: backText; shortcut: "shortcut_back" }
    ShortcutTextField { id: backText1; shortcut: "shortcut_back1" }
    Label { text: 'Select' }
    ShortcutTextField { id: selectText; shortcut: "shortcut_select" }
    ShortcutTextField { id: selectText1; shortcut: "shortcut_select1" }
    Label { text: 'Context Menu' }
    ShortcutTextField { id: contextText; shortcut: "shortcut_context" }
    ShortcutTextField { id: contextText1; shortcut: "shortcut_context1" }
    Label { text: 'Info' }
    ShortcutTextField { id: infoText; shortcut: "shortcut_info" }
    ShortcutTextField { id: infoText1; shortcut: "shortcut_info1" }
    Label { text: 'Home' }
    ShortcutTextField { id: homeText; shortcut: "shortcut_home" }
    ShortcutTextField { id: homeText1; shortcut: "shortcut_home1" }
    Label { text: 'Enter Text' }
    ShortcutTextField { id: enterTextText; shortcut: "shortcut_enterText" }
    ShortcutTextField { id: enterTextText1; shortcut: "shortcut_enterText1" }
    Label { text: 'Settings' }
    ShortcutTextField { id: settingsText; shortcut: "shortcut_settings" }
    ShortcutTextField { id: settingsText1; shortcut: "shortcut_settings1" }
    Label { text: 'PlayPause' }
    ShortcutTextField { id: playpauseText; shortcut: "shortcut_playpause" }
    ShortcutTextField { id: playpauseText1; shortcut: "shortcut_playpause1" }
    Label { text: 'Stop' }
    ShortcutTextField { id: stopText; shortcut: "shortcut_stop" }
    ShortcutTextField { id: stopText1; shortcut: "shortcut_stop1" }
    Label { text: 'Next' }
    ShortcutTextField { id: nextText; shortcut: "shortcut_next" }
    ShortcutTextField { id: nextText1; shortcut: "shortcut_next1" }
    Label { text: 'Previous' }
    ShortcutTextField { id: previousText; shortcut: "shortcut_previous" }
    ShortcutTextField { id: previousText1; shortcut: "shortcut_previous1" }
    Label { text: 'Show OSD' }
    ShortcutTextField { id: osdText; shortcut: "shortcut_osd" }
    ShortcutTextField { id: osdText1; shortcut: "shortcut_osd1" }
    Label { text: 'PlayPause / Select' }
    ShortcutTextField { id: playpauseselectText; shortcut: "shortcut_playpauseselect" }
    ShortcutTextField { id: playpauseselectText1; shortcut: "shortcut_playpauseselect1" }

    Button {
        id: getShortcutStringButton
        checkable: true
        focus: checked
        onClicked: {
            console.log(focus)
            focus = checked
        }
        Keys.enabled: true
        Keys.onPressed: {
            event.accepted = true
            console.log(event.key)
            console.log(event.text)
            console.log(event.modifiers)
            //testAction.shortcut = ''
            //console.log(testAction.shortcut)
        }
    }

    // makes sure all other elements are aligned at the top
    Rectangle {
        id: invisiRec
        Layout.fillHeight: true
        Layout.columnSpan: 3
    }

    Button { action: backAction }
    Text { text: ' ' }
    Button { action: applyAction; Layout.alignment: Qt.AlignRight }
}
}
}
