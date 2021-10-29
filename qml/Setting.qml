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
  property alias strideValue: strideText.text
  property alias sensitivityValue: sensitivitySlider.value
  property int mSpacing: units.gu(1)

  signal applyChanges
  signal cancelChanges

  header: PageHeader {
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

  Column {
    id: column
    width: parent.width
    anchors {
      top: settingPage.header.bottom;
      left: parent.left; leftMargin: mSpacing
      right: parent.right; rightMargin: mSpacing
    }

    ListItem {
      height: sexLabel.height + sexValue.height + 3 * mSpacing
      Label {
        id: sexLabel
        text: i18n.tr("Sex")
        width: parent.width
        anchors {
          top: parent.top; topMargin: mSpacing
        }
      }

      ComboButton {
        id: sexValue
        expandedHeight: -1
        width: parent.width
        anchors {
          top: sexLabel.bottom; topMargin: mSpacing
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
                calStride()
              }
            }
          }
        }
      }
    }

    ListItem {
      height: agelabel.height + ageText.height + 3 * mSpacing
      Label {
        id: agelabel
        text: i18n.tr("Age")
        anchors {
          top: parent.top; topMargin: mSpacing
        }
      }

      TextInput {
        id:ageText
        width: parent.width
        anchors {
          top: agelabel.bottom; topMargin: mSpacing
        }
        validator: IntValidator{bottom: 1;}
        focus: true
      }
    }

    ListItem {
      height: heightlabel.height + heightText.height + 3 * mSpacing
      Label {
        id: heightlabel
        text: i18n.tr("Height (cm)")
        anchors {
          top: parent.top; topMargin: mSpacing
        }
      }

      signal editingFinished()

      TextInput {
        id: heightText
        width: parent.width
        anchors {
          top: heightlabel.bottom; topMargin: mSpacing
        }
        validator: DoubleValidator{bottom: 1.00; decimals: 2;}
        focus: true
        onEditingFinished: calStride()
      }
    }

    ListItem {
      height: weightlabel.height + weightText.height + 3 * mSpacing
      Label {
        id:weightlabel
        text: i18n.tr("Weight (kg)")
        anchors {
          top: parent.top; topMargin: mSpacing
        }
      }

      TextInput {
        id:weightText
        width: parent.width
        anchors {
          top: weightlabel.bottom; topMargin: mSpacing
        }
        validator: DoubleValidator{bottom: 1.00; decimals: 2;}
        focus: true
      }
    }

    ListItem {
      height: stridelabel.height + strideText.height + 3 * mSpacing
      Label {
        id: stridelabel
        text: i18n.tr("Stride (cm)")
        anchors {
          top: parent.top; topMargin: mSpacing
        }
      }

      TextInput {
        id: strideText
        width: parent.width
        anchors {
          top: stridelabel.bottom; topMargin: mSpacing
        }
      }
    }

    ListItem {
      height: sensitivitylabel.height + sensitivitySlider.height + 3 * mSpacing
      Label {
        id: sensitivitylabel
        text: i18n.tr("Sensitivity")
        anchors {
          top: parent.top; topMargin: mSpacing
        }
      }

      Slider {
        id: sensitivitySlider
        minimumValue: 1
        maximumValue: 10
        width: parent.width
        anchors {
          top: sensitivitylabel.bottom; topMargin: mSpacing
        }
      }
    }
  }

  //Calculate stride in cm based on demoraphic information
  function calStride() {
    if (sexValue.text == "Male") {
      strideText.text = Math.round(heightText.text * 0.3937008 * 0.415 * 100) / 100
    } else {
      strideText.text = Math.round(heightText.text * 0.3937008 * 0.413 * 100) / 100
    }
  }
}
