# Steps
This application counts steps based on accelerometer data and calculates travelled distance based on computed stride length [1-2] using the user's demographic information. Inspired by [3] and [4].

## How it works
When a new accelerometer datapoint becomes available, it is fed into `calMag` function to calculate magnitude. Then, every one second, if at least 60 magnitude values are accumulated, the process of counting steps starts by calling `countSteps`. First, the average of the collected magnitudes is calculated and subtracted from each point. Then, the resulting values are compared with a constant value of eight, approximating the standard deviation of magnitude when walking. However, to have a more reliable result, an algorithm is required to detect walking and then calculate the standard deviation of the collected magnitudes over time.

## References
[1] Chung, S. Long Walk Shirley Chung AT Still University

[2] Barreira, T. V., Rowe, D., & Kang, M. (2010). Parameters of walking and jogging in healthy young adults. International Journal of Exercise Science, 3(1), 4-13

[3] Counting Steps by Capturing Acceleration Data from Your Mobile Device - MATLAB &amp; Simulink. Retrieved October 20, 2021, from https://www.mathworks.com/help/matlabmobile_android/ug/counting-steps-by-capturing-acceleration-data.html.

[4] Clime, C. sensorsstatus. OpenStore. Retrieved October 20, 2021, from https://open-store.io/app/sensorsstatus.chrisclime.

## Notes
For the app to work correctly, the app should be prevented from suspension by following these steps:
- Open "UT Tweak Tool"
- Go to "Apps + Scopes"
- Click on "Steps"
- Activate "Prevent app suspension"

## Test cases
The app has been tested on Nexus 6P, Pixel 3A, Poco F1, Sony Xperia X and PinePhone. 

## Limitation
The device should be in the pocket.

## Download
[![OpenStore](https://open-store.io/badges/en_US.png)](https://open-store.io/app/steps.jranaraki)

## License
Copyright (C) 2021  Javad Rahimipour Anaraki

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License version 3, as published
by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranties of MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
