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
import QtQuick.Controls 2.5 as QT
import Ubuntu.Components 1.3
import QtQuick.Window 2.2  //to read screen orientation

Page {
  id: settingPage

  property alias sex: sexValue.text
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
        height: sexLabel.height + sexValue.height + 3 * mSpacing
        divider.visible: false
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
        id: ageItem
        height: agelabel.height + ageText.height + 3 * mSpacing
        divider.visible: false
        Label {
          id: agelabel
          text: i18n.tr("Age")
          anchors {
            top: parent.top; topMargin: mSpacing
          }
        }
        TextField {
          id:ageText
          width: parent.width
          anchors {
            top: agelabel.bottom; topMargin: mSpacing
          }
          validator: IntValidator{bottom: 1;}
        }
      }
      ListItem {
        id: heightItem
        height: heightlabel.height + heightText.height + 3 * mSpacing
        divider.visible: false
        Label {
          id: heightlabel
          text: i18n.tr("Height (cm)")
          anchors {
            top: parent.top; topMargin: mSpacing
          }
        }
        TextField {
          id: heightText
          width: parent.width
          anchors {
            top: heightlabel.bottom; topMargin: mSpacing
          }
          validator: DoubleValidator{bottom: 1.00; decimals: 2;}
          onTextChanged: calStride()
        }
      }
      ListItem {
        id: weightItem
        height: weightlabel.height + weightText.height + 3 * mSpacing
        divider.visible: false
        Label {
          id:weightlabel
          text: i18n.tr("Weight (kg)")
          anchors {
            top: parent.top; topMargin: mSpacing
          }
        }
        TextField {
          id:weightText
          width: parent.width
          anchors {
            top: weightlabel.bottom; topMargin: mSpacing
          }
          validator: DoubleValidator{bottom: 1.00; decimals: 2;}
        }
      }
      ListItem {
        id: strideItem
        height: stridelabel.height + strideText.height + 3 * mSpacing
        divider.visible: false
        Label {
          id: stridelabel
          text: i18n.tr("Stride (cm)")
          anchors {
            top: parent.top; topMargin: mSpacing
          }
        }
        TextField {
          id: strideText
          width: parent.width
          anchors {
            top: stridelabel.bottom; topMargin: mSpacing
          }
          onFocusChanged: waitForKeyboardTimer.start()
        }
      }
      ListItem {
        id: sensitivityItem
        height: sensitivitylabel.height + sensitivitySlider.height + 3 * mSpacing
        divider.visible: false
        Label {
          id: sensitivitylabel
          text: i18n.tr("Sensitivity") + " (7 - 12)"
          anchors {
            top: parent.top; topMargin: mSpacing
          }
        }
        Row {
          anchors{
            top: sensitivitylabel.bottom
            topMargin: mSpacing
            left: parent.left
            leftMargin: mSpacing
            right: parent.right
            rightMargin: mSpacing
          }
          QT.Slider {
            id: sensitivitySlider
            from: 7.0
            to: 12.0
            stepSize: 0.25
            snapMode: Slider.SnapAlways
            live: true
            handle.height: units.gu(2)
            handle.width: handle.height
            width: parent.width - units.gu(7)
            anchors.verticalCenter: parent.verticalCenter
          }
          Label {
              id: valueLabel
              text: sensitivitySlider.value.toLocaleString(Qt.locale(),"f",2)
              width: units.gu(7)
              horizontalAlignment: Text.AlignRight
          }
        }
      }
      ListItem {
        id: goalItem
        height: goallabel.height + goalText.height + 3 * mSpacing
        divider.visible: false
        Label {
          id: goallabel
          text: i18n.tr("Goal (steps)")
          anchors {
            top: parent.top; topMargin: mSpacing
          }
        }
        TextField {
          id: goalText
          width: parent.width
          anchors {
            top: goallabel.bottom; topMargin: mSpacing
          }
          validator: IntValidator{bottom: 1;}
          onFocusChanged: waitForKeyboardTimer.start()
        }
      }
      Item {
        id: flickableSizeSpacer
        height: 0
      }
      /*
      The bottom components are hidden by the OSK when entering the text fields.
      To avoid this, the flickable's position needs to adjust accordingly.
      Only when the flickables height is more than the column items cumulated height it can be flicked.
      To cover this, a spacer item is added at the bottom whichs height is changed on demand.

      The height of the keyboard, as one offset parameter, is not available to read instantly.
      It does take about 200ms for the OSK to raise. Only then the height can be queried.

      For some reason in landscape there is another offset. This is added as fixed value.
      */
      Timer {
        id: waitForKeyboardTimer
        interval: 250 //the osk should be fully raised after that time
        onTriggered: {
          flickableSizeSpacer.height = settingPage.height
          var landscapeOffset = Screen.orientation === 2 ? 250 : 0
          var constOffset = settingsFlickable.contentY + Qt.inputMethod.keyboardRectangle.height + landscapeOffset
          if (goalText.focus) {
            var goalOffset = column.height - goalItem.y
            settingsFlickable.contentY = constOffset - goalOffset
          } else if (strideText.focus) {
            var strideOffset = column.height - strideItem.y
            settingsFlickable.contentY = constOffset - strideOffset
          } else {
              flickableSizeSpacer.height = 0
              settingsFlickable.returnToBounds()
          }
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