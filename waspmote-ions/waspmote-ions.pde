
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
  delay(1000);  
}
