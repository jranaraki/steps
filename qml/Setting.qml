/*
* Copyright (C) 2023  Javad Rahimipour Anaraki
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
import QtQuick.Controls 2.5 as QT
import Lomiri.Components 1.3
import QtQuick.Window 2.2
import QtQml 2.0

Page {
    id: settingPage

    property alias sex: sexComboBox.currentIndex
    property alias age: ageText.text
    property alias heightValue: heightText.text
    property alias weightValue: weightText.text
    property alias strideValue: strideText.text
    property alias sensitivityValue: sensitivitySlider.value
    property alias goalValue: goalText.text
    property int mSpacing: units.gu(1)

    signal applyChanges
    signal cancelChanges

    header: PageHeader {
        id: header
        title: i18n.tr("Settings")

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

    Flickable {
        id: settingsFlickable
        clip: true
        flickableDirection: Flickable.AutoFlickIfNeeded
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            anchors {
                left: parent.left; leftMargin: mSpacing
                right: parent.right; rightMargin: mSpacing
            }

            ListItem {
                id: sexItem
                height: sexComboBox.height + 5 * mSpacing
                divider.visible: false

                Label {
                    id: sexLabel
                    text: i18n.tr("Sex")
                    width: parent.width
                    anchors {
                        top: parent.top; topMargin: mSpacing
                    }
                }

                QT.ComboBox {
                    id: sexComboBox
                    anchors {
                        top: sexLabel.bottom; topMargin: mSpacing
                    }
                    width: parent.width
                    editable: false
                    model: [i18n.tr("Female"), i18n.tr("Male")]
                    onCurrentIndexChanged: {
                        sexComboBox.currentIndex = sexComboBox.currentIndex
                        calStride()
                    }
                }
            }

            ListItem {
                id: ageItem
                height: ageText.height + 5 * mSpacing
                divider.visible: false

                Label {
                    id: ageLabel
                    text: i18n.tr("Age")
                    anchors {
                        top: parent.top; topMargin: mSpacing
                    }
                }

                TextField {
                    id:ageText
                    width: parent.width
                    anchors {
                        top: ageLabel.bottom; topMargin: mSpacing
                    }
                    validator: IntValidator{bottom: 1;}
                }
            }

            ListItem {
                id: heightItem
                height: heightText.height + 5 * mSpacing
                divider.visible: false

                Label {
                    id: heightLabel
                    text: i18n.tr("Height (cm)")
                    anchors {
                        top: parent.top; topMargin: mSpacing
                    }
                }

                TextField {
                    id: heightText
                    width: parent.width
                    anchors {
                        top: heightLabel.bottom; topMargin: mSpacing
                    }
                    validator: DoubleValidator{bottom: 1.00; decimals: 2;}
                    onTextChanged: calStride()
                }
            }

            ListItem {
                id: weightItem
                height: weightText.height + 5 * mSpacing
                divider.visible: false

                Label {
                    id:weightLabel
                    text: i18n.tr("Weight (kg)")
                    anchors {
                        top: parent.top; topMargin: mSpacing
                    }
                }

                TextField {
                    id:weightText
                    width: parent.width
                    anchors {
                        top: weightLabel.bottom; topMargin: mSpacing
                    }
                    validator: DoubleValidator{bottom: 1.00; decimals: 2;}
                }
            }

            ListItem {
                id: strideItem
                height: strideText.height + 5 * mSpacing
                divider.visible: false

                Label {
                    id: strideLabel
                    text: i18n.tr("Stride (cm)")
                    anchors {
                        top: parent.top; topMargin: mSpacing
                    }
                }

                TextField {
                    id: strideText
                    width: parent.width
                    anchors {
                        top: strideLabel.bottom; topMargin: mSpacing
                    }
                    onFocusChanged: waitForKeyboardTimer.start()
                }
            }

            ListItem {
                id: sensitivityItem
                height: sensitivitySlider.height + 4 * mSpacing
                divider.visible: false

                Label {
                    id: sensitivityLabel
                    text: i18n.tr("Sensitivity")
                    anchors {
                        top: parent.top; topMargin: mSpacing
                    }
                }

                Row {
                    anchors{
                        top: sensitivityLabel.bottom
                        topMargin: mSpacing
                        left: parent.left
                        leftMargin: mSpacing
                        right: parent.right
                        rightMargin: mSpacing
                    }
                    QT.Slider {
                        id: sensitivitySlider
                        from: 0.0
                        to: 5.0
                        stepSize: 0.1
                        live: true
                        handle.height: units.gu(2)
                        handle.width: units.gu(2)
                        width: parent.width - valueLabel.width
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        id: valueLabel
                        text: sensitivitySlider.value.toLocaleString(Qt.locale(), "f", 2)
                        width: units.gu(4)
                        horizontalAlignment: Text.AlignRight
                        anchors.bottom: sensitivitySlider.verticalCenter
                    }
                }
            }

            ListItem {
                id: goalItem
                height: goalText.height + 5 * mSpacing
                divider.visible: false

                Label {
                    id: goalLabel
                    text: i18n.tr("Goal (steps)")
                    anchors {
                        top: parent.top; topMargin: mSpacing
                    }
                }

                TextField {
                    id: goalText
                    width: parent.width
                    anchors {
                        top: goalLabel.bottom; topMargin: mSpacing
                    }
                    validator: IntValidator{bottom: 1;}
                    focus: true
                }
            }
        }
    }

    //Calculate stride in cm based on demoraphic information
    function calStride() {
        if (sexComboBox.currentIndex === 1) {
            strideText.text = Math.round(heightText.text * 0.3937008 * 0.415 * 100) / 100
        } else {
            strideText.text = Math.round(heightText.text * 0.3937008 * 0.413 * 100) / 100
        }
    }
}
