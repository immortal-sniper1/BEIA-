/*  
 *  ------ [SWI_01] - Temperature Sensor Reading for Smart Water Ions-------- 
 *  
 *  Explanation: Turn on the Smart Water Ions Board and reads the Temperature
 *  sensor printing the result through the USB
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify 
 *  it under the terms of the GNU General Public License as published by 
 *  the Free Software Foundation, either version 3 of the License, or 
 *  (at your option) any later version. 
 *  
 *  This program is distributed in the hope that it will be useful, 
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *  GNU General Public License for more details. 
 *  
 *  You should have received a copy of the GNU General Public License 
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 *  
 *  Version:           3.0
 *  Design:            David Gascón 
 *  Implementation:    Ahmad Saad
 */

#include <smartWaterIons.h>

// Create an instance of the class
pt1000Class TemperatureSensor;

void setup()
{
  // Turn on the Smart Water Sensor Board and start the USB
  SWIonsBoard.ON();
  USB.ON();  
}

void loop()
{
  // Reading of the Temperature sensor
  float temperature = TemperatureSensor.read();

  // Print of the results
  USB.print(F("Temperature (Celsius degrees): "));
  USB.println(temperature);
  
  // Delay
  delay(10000);  
}





/*



A code for reading the sensor is shown below:
int value;
{
SensorEventv20.ON();
delay(10);
value = SensorEventv20.readValue(SOCKET);
}
value is an integer variable where the sensor state (a high value (3.3V) indicating liquid presence or a low value (0V) indicating
its absence) will be stored.
SOCKET indicates on which connector the sensor is placed (for this sensor it may be SENS_SOCKET1, SENS_SOCKET2, SENS_
SOCKET3 and SENS_SOCKET8).







A code for reading the sensor is shown below:
int value;
{
SensorEventv20.ON();
delay(10);
value = SensorEventv20.readValue(SOCKET);
}
value is an integer variable where the sensor state (a high value (3.3V) indicating that the sensor is closed or a low value (0V)
indicating that it is open) will be stored.
SOCKET indicates on which connector the sensor is placed (for this sensor it may be SENS_SOCKET1, SENS_SOCKET2, SENS_
SOCKET3 and SENS_SOCKET8).


 */
