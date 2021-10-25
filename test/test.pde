/*
    ----------- [Ag_xtr_12] - Pythos31 sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Leaf wetness

    Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see .

    Version:           3.1
    Design:            David Gascón
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_B           _________
                          |---------|
                          | A  B  C |
                          |_D__E__F_|


  Example: a 5TM sensor on socket A will be
  [Sensor Class] [Sensor Name] [Selected socket]
  Decagon_5TM    mySensor      (XTR_SOCKET_A);

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

//   [Sensor Class] [Sensor Name]
leafWetness mySensor3;




int frunzarie()
{
  int wett=-5;

  // 2. Turn ON the sensor
  mySensor3.ON();

  // 3. Read the sensor. Values stored in class variables
  // Check complete code example for details
  mySensor3.read();

  // 4. Turn off the sensor
  mySensor3.OFF();

  // 4. Print information

  USB.println(F("Pythos31"));
  USB.print(F("Leaf wetness:"));
  wett = mySensor3.wetness;
  USB.printFloat(wett , 4);
  USB.println(F(" V"));
  
  return wett;
}








void setup()
{
  USB.println(F("Pythos31 example"));
}

void loop()
{
int rr;

rr=frunzarie();

  delay(5000);

}
