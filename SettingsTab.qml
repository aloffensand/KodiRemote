import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Tab {
    id: settingsTab
    title: 'Settings'

    Row {
        anchors.fill: parent
        spacing: 1

        Column {
            id: tabSelection

            Repeater {
                model: settingsTabView.count
                ToolButton {
                    text: {
                        if (settingsTabView.getTab(index).title == null) {
                            'Untitled'
                        } else {
                            settingsTabView.getTab(index).title
                        }
                    }
                    iconName: {
                        if (settingsTabView.getTab(index).iconName == null) {
                            'empty'
                        } else {
                            settingsTabView.getTab(index).iconName
                        }
                    }
                    iconSource: 'icons/' + iconName + '.png'
                    tooltip: text

                    onClicked: settingsTabView.currentIndex = index
                }
            }
        }

        Rectangle {
            height: parent.height
            width: 5
            border.width: 2
            border.color: systemPalette.base
            color: systemPalette.text
        }

        TabView {
            id: settingsTabView
            height: parent.height
            width: parent.width - x
            frameVisible: false
            tabsVisible: false
            focus: true

            onCurrentIndexChanged: {
                getTab(currentIndex).forceActiveFocus()
            }

            Tab {
                id: generalSettingsTab
                title: 'General'
                property string iconName: 'configure'
                ScrollView {
                    anchors.fill: parent
                    Rectangle {
                        width: childrenRect.width + margins*2
                        height: childrenRect.height + margins*2
                        color: "transparent"
                        GeneralSettings {
                            x: margins
                            y: margins
                        }
                    }
                }
            }
            Tab {
                id: shortcutSettingsTab
                title: 'Shortcuts'
                property string iconName: 'preferences-desktop-keyboard'
                //property string iconName: 'configure-shortcuts'
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
            Tab {
                id: videoSettingsTab
                title: 'Video'
                property string iconName: 'applications-multimedia'
                ScrollView {
                    anchors.fill: parent
                    Rectangle {
                        width: childrenRect.width + margins*2
                        height: childrenRect.height + margins*2
                        color: "transparent"
                        VideoSettings {
                            id: videoSettings
                            x: margins
                            y: margins
                        }
                    }
                }
            }
            Tab {
                id: skipIntroSettingsTab
                title: 'SkipIntro'
                property string iconName: ''
                ScrollView {
                    anchors.fill: parent
                    Rectangle {
                        width: childrenRect.width + margins*2
                        height: childrenRect.height + margins*2
                        color: "transparent"
                        SkipIntroSettings {
                            id: skipIntroSettings
                            x: margins
                            y: margins
                        }
                    }
                }
            }
        }
    }
}
