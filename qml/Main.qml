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
import UserMetrics 0.1

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
  Metric { // Define the Metric object.
    property string circleMetric
    id: metric // A name to reference the metric elsewhere in the code. i.e. when updating format values below.
    name: "stepsMetric" // This is a unique ID for storing the user metric data
    format: i18n.tr("%1 Steps walked today.") // This is the metric/message that will display "today". Again it uses the string variable that we defined above
    emptyFormat: i18n.tr("No hike measured today.") // This is the metric/message for tomorrow. It will "activate" once the day roles over and replaces "format". Here I have use a simple translatable string instead of a variable because I didn’t need it to change.
    domain: "steps.jranaraki" // This is the appname, based on what you have in your app settings. Presumably this is how the system lists/ranks the metrics to show on the lock screen.
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
