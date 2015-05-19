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
        property int margins: 10

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
            ScrollView {
                anchors.fill: parent
                Rectangle {
                    width: childrenRect.width + margins*2
                    height: childrenRect.height + margins*2
                    GeneralSettings {
                        x: margins
                        y: margins
                    }
                }
            }
        }
        Tab {
            id: shortcutSettingsTab
            ScrollView {
                anchors.fill: parent
                Rectangle {
                    width: childrenRect.width + margins*2
                    height: childrenRect.height + margins*2
                    color: "transparent"
                    ShortcutSettings {
                        id: shortcutSettings
                        x: margins
                        y: margins
                    }
                }
            }
        }
    }
}
