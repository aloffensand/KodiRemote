import QtQuick 2.2
import QtQuick.Controls 1.2

// This type needs an item called frame in which the shortcut strings are saved
// as well as a SystemPalette called systemPalette.
// Usage:
// The shortcuts must be defined in an item called "frame". Alternatively,
// change "frame" here to something different.
//  - shortcut: Set to the name of the shortcut variable (e.g. "shortcut_left")
//  - valid: Set to false if the shortcut is not recognised by QML
//  - unique: Set to false if another ShortcutTextField has the same text
TextField {
    property string shortcut: ""
    property bool valid: true
    property bool unique: true
    text: frame[shortcut]
    // FIXME: use colors from the system's theme
    //textColor: (! valid) ? 'red' : (! unique) ? 'orange' : 'black'
    textColor: (! valid) ? 'red' :
               (! unique) ? 'orange' :
               systemPalette.text
}
