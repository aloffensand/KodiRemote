import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Tab {
    id: settingsTab
    title: 'Settings'

    TabView {
        id: settingsTabView
        frameVisible: false
        tabsVisible: false
        focus: true

        onCurrentIndexChanged: {
            getTab(currentIndex).forceActiveFocus()
        }

        Tab {
            Grid {
                anchors.fill: parent
                anchors.margins: parent.height / 20
                spacing: 10

                Button {
                    text: "General"
                    iconName: "something"
                    iconSource: "icons/" + iconName + ".png"
                    onClicked: settingsTabView.currentIndex = 1
                }
                Button {
                    text: "Shortcuts"
                    iconName: "preferences-desktop-keyboard"
                    iconSource: "icons/" + iconName + ".png"
                    onClicked: settingsTabView.currentIndex = 2
                }
            }
        }
        Tab {
            id: generalSettingsTab
            GeneralSettings {}
        }
        Tab {
            id: shortcutSettingsTab
            //ScrollView {
                //anchors.fill: parent
                //Rectangle {
                    //anchors { top: parent.top; left: parent.left }
                    //width: Math.max(childrenRect.width + shortcutSettings.margins*2, parent.width)
                    //height: Math.max(childrenRect.height + shortcutSettings.margins*2, parent.height)
                    ShortcutSettings { id: shortcutSettings }
                //}
            //}
        }
    }
}
