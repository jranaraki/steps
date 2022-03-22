/*
* Copyright (C) 2022  Javad Rahimipour Anaraki
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
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import QtSensors 5.2

import "../js/db.js" as StepsDB

Page {
  id: mainPage
  anchors.fill: parent

  property var nSteps: 0
  property var distance: 0
  property var freq: 60
  property var magTemp: []
  property var magData: []
  property var line: []
  property var listIndex: 0
  property var today: ""
  property var pace: 0.0

  header: PageHeader {
    id: header
    title: i18n.tr('Steps')

    trailingActionBar.actions: [
    Action {
      text: i18n.tr("Settings")
      onTriggered: mainView.showSettings()
      iconName: "settings"
    },
    Action {
      text: i18n.tr("About")
      onTriggered: pStack.push(Qt.resolvedUrl("About.qml"))
      iconName: "info"
    }
    ]
    Component.onCompleted: initialize()
  }

  //Initialize the list
  function initialize() {
    var d = new Date()
    today = d.toDateString()
    var found = StepsDB.findStep(today)

    //Retreiving data from the dataset and sorting the rows
    listModel.clear()
    var stepsData = StepsDB.getSteps()
    for (var i = stepsData.rows.length - 1; i >=0 ; i--) {
      listModel.append({"date": stepsData.rows[i].date, "steps": stepsData.rows[i].steps, "distance": stepsData.rows[i].distance})
    }

    if (found.rows.length > 0) {
      nSteps = found.rows[0].steps
      return
    } else {
      listModel.insert(0, {"date": today, "steps": 0, "distance": 0})
      StepsDB.storeSteps(today, 0, 0)
    }
  }

  //Calculate average of an array
  function mean(inArray) {
    var sum = 0
    for (var i = 0; i < inArray.length; i++) {
      sum += inArray[i]
    }
    return (sum / inArray.length)
  }

  //Calculate standard deviation of an array
  function std(inArray) {
    var sum = 0
    var m = mean(inArray)
    for (var i = 0; i < inArray.length; i++) {
      sum += Math.pow(inArray[i] - m, 2)
    }
    return (Math.sqrt(sum / inArray.length))
  }

  //Add accelerometer values to accData
  function calMag() {
    magTemp.push(Math.sqrt(Math.pow(accelerometer.reading.x, 2) + Math.pow(accelerometer.reading.y, 2) + Math.pow(accelerometer.reading.z, 2)))
  }

  //Count steps
  function countSteps()
  {
    var magNoG = []
    var meanMag = 0
    var tmpSteps = 0

    if (magTemp.length < freq) {
      return
    } else {
      magData = magTemp.slice(-freq)
      magTemp = []
    }

    meanMag = mean(magData)
    for (var i = 0; i < freq; i++){
      magNoG.push(magData[i] - meanMag)
    }

    for (var i = 0; i < magNoG.length - 1; i++){
      if ((magNoG[i] - magNoG[i+1]) > (11 - (preferences.sensitivityValue + 7.0))) {
        nSteps = nSteps + 1
        distance = Math.round(nSteps * preferences.strideValue) / 100
        tmpSteps = tmpSteps + 1
        listModel.setProperty(listIndex, "steps", nSteps)
        listModel.setProperty(listIndex, "distance", distance)
        StepsDB.storeSteps(today, nSteps, distance)
      }
    }
  }

  visible: accelerometer.connectedToBackend
  Accelerometer {
    id: accelerometer
    active: true

    onReadingChanged: {
      calMag();
    }
  }

  ListModel {
    id: listModel
  }

  ListView {
    anchors {
      top: header.bottom
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }
    width: parent.width
    height: parent.height
    clip: true
    id: thelist
    model: listModel

    delegate: ListItem {
      id: del

      ListItemLayout {
        ProportionalShape {
          SlotsLayout.position: SlotsLayout.Leading
          source: Image { source: "../Images/walk.svg" }
          height: del.height-units.gu(2)
          aspect: UbuntuShape.DropShadow
        }
        title.text: date
        subtitle.text: i18n.tr("Steps: %1").arg(steps.toLocaleString(Qt.locale(),"f",0)) + ", " + i18n.tr("Distance: %1 m").arg(distance.toLocaleString(Qt.locale(),"f",1))

        ProportionalShape {
          SlotsLayout.position: SlotsLayout.Trailing
          source: Image { source: "../Images/trophy.svg" }
          height: del.height-units.gu(2)
          aspect: UbuntuShape.DropShadow
          visible: steps >= preferences.goalValue ? true : false
        }
      }

      leadingActions: ListItemActions {
        actions: [
        Action {
          iconName: "delete"
          onTriggered: {
            StepsDB.deleteSteps(listModel.get(index).date)
            listModel.remove(index)
          }
        }
        ]
      }
    }
  }

  //Timer to trigger countSteps
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: countSteps()
  }
}
