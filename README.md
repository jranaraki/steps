# Steps

This application counts your steps based on accelerometer data and calculates travelled distance based on computed stride using the user's demographic information. 

## How it works

When a new accelerometer datapoint becomes available, it is fed into `calMag` function to calculate magnitude. Then, every one second, if at least 60 magnitude values are accumulated, the process of counting steps starts by calling `countSteps`. First, the average of the collected magnitudes is calculated and subtracted from each point. Then, the resulting values are compared with a constant value of eight, approximating the standard deviation of magnitude when walking. However, to have a more reliable result, an algorithm is required to detect walking and then calculate the standard deviation of the collected magnitudes over time.

## Test cases

The app has been tested on Nexus 6P and Pixel 3A. 

## License

Copyright (C) 2021  Javad Rahimipour Anaraki

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License version 3, as published
by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranties of MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
