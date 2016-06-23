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
            // It's a Tab! I mean … a tab bar.
            id: tabSelection

            Repeater {
                model: settingsTabView.count
                ToolButton {
                    id: tabButton
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
                    iconSource: 'qrc:///icons/' + iconName + '.png'
                    tooltip: text
                    checkable: true
                    states: [
                        State {
                            when: settingsTabView.currentIndex == index
                            PropertyChanges {
                                target: tabButton; checked: true
                            }
                        }, State {
                            when: settingsTabView.currentIndex != index
                            PropertyChanges {
                                target: tabButton; checked: false
                            }
                        }
                    ]
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
