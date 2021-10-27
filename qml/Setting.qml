/*
 * Copyright (C) 2021  Javad Rahimipour Anaraki
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * steps is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: settingPage

    property alias sex: sexValue.text
    property alias age: ageText.text
    property alias heightValue: heightText.text
    property alias weightValue: weightText.text

    signal applyChanges
    signal cancelChanges

    header: PageHeader {
        title: i18n.tr("Settings")
        flickable: scrollView.flickableItem

        leadingActionBar.actions: Action {
            text: i18n.tr("Cancel")
            iconName: "close"
            onTriggered: {
                settingPage.cancelChanges();
                pageStack.pop();
            }
        }

        trailingActionBar.actions: Action {
            text: i18n.tr("Apply")
            iconName: "ok"
            onTriggered: {
                settingPage.applyChanges();
                pageStack.pop();
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        Column {
            id: column
            width: scrollView.width

            property int mSpacing: units.gu(1)

            ListItem {
                height: sexLabel.height + sexValue.height + 3 * column.mSpacing
                Label {
                    id: sexLabel
                    text: i18n.tr("Sex")
                    anchors {
                        top: parent.top; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
                ComboButton {
                    id: sexValue
                    expandedHeight: -1
                    width: parent.width
                    anchors {
                        top: sexLabel.bottom; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }

                    Column {
                        Repeater {
                            model: ["Male", "Female"]
                            Button {
                                text: modelData
                                width: parent.width
                                onClicked: {
                                    sexValue.text = text;
                                    sexValue.expanded = false;
                                }
                            }
                        }
                    }
                }
            }

            ListItem {
                height: agelabel.height + ageText.height + 3 * column.mSpacing
                Label {
                    id: agelabel
                    text: i18n.tr("Age")
                    anchors {
                        top: parent.top; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }

                TextField {
                    id:ageText
                    width: parent.width
                    // anchors.top: agelabel.bottom
                    anchors {
                        top: agelabel.bottom; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
            }

            ListItem {
                height: heightlabel.height + heightText.height + 3 * column.mSpacing
                Label {
                    id:heightlabel
                    text: i18n.tr("Height (cm)")
                    anchors {
                        top: parent.top; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }

                TextField {
                    id:heightText
                    width: parent.width
                    anchors {
                        top: heightlabel.bottom; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
            }

            ListItem {
                height: weightlabel.height + weightText.height + 3 * column.mSpacing
                Label {
                    id:weightlabel
                    text: i18n.tr("Weight (kg)")
                    anchors {
                        top: parent.top; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }

                TextField {
                    id:weightText
                    width: parent.width
                    anchors {
                        top: weightlabel.bottom; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
            }
        }
    }
}
