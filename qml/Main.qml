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

import QtQuick 2.7
import Lomiri.Components 1.3
import Qt.labs.settings 1.0

MainView {
  id: mainView
  objectName: 'mainView'
  applicationName: 'steps.jranaraki'
  automaticOrientation: true

  width: units.gu(45)
  height: units.gu(75)

  Component.onCompleted: {
    pStack.push(Qt.resolvedUrl("MainPage.qml"));
  }

  Settings {
    id: preferences
    property int sex: 0
    property int age: 30
    property double heightValue: 160.0
    property double weightValue: 75.0
    property double strideValue: 30.0
    property double sensitivityValue: 1.0
    property int goalValue: 10000
    property int commonMargin: units.gu(2)
  }

  PageStack {
    id: pStack
  }

  function showSettings() {
    var prop = {
      sex: preferences.sex,
      age: preferences.age,
      heightValue: preferences.heightValue,
      weightValue: preferences.weightValue,
      strideValue: preferences.strideValue,
      sensitivityValue: preferences.sensitivityValue,
      goalValue: preferences.goalValue,
    }

    var slot_applyChanges = function(msettings) {
      preferences.sex = msettings.sex;
      preferences.age = msettings.age;
      preferences.heightValue = msettings.heightValue;
      preferences.weightValue = msettings.weightValue;
      preferences.strideValue = msettings.strideValue;
      preferences.sensitivityValue = msettings.sensitivityValue;
      preferences.goalValue = msettings.goalValue;
    }

    var settingPage = pStack.push(Qt.resolvedUrl("Setting.qml"), prop);
    settingPage.applyChanges.connect(function() { slot_applyChanges(settingPage) });
  }
}
