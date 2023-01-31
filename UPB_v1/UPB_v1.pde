
// Put your libraries here (#include ...)
#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>
#include <WaspWIFI_PRO.h>

char node_ID[] = "upb_yest";

Gas CO(SOCKET_B);
Gas CO2(SOCKET_A);

  float temperature;
  float humidity;
  float pressure;

void BME280_thing()
{

// Reads the BME280 sensor
temperature = gas_sensor.getTemp(1);
// Reads the environmetal humidity from BME280 sensor
humidity = gas_sensor.getHumidity();
// Reads the environmetal pressure from BME280 sensor
pressure = gas_sensor.getPressure();

}



void setup()
{
  // put your setup code here, to run once:
  // Open the USB connection
  USB.ON();
  USB.println(F("USB port started..."));
  RTC.ON();



}


void loop()
{
  // put your main code here, to run repeatedly:


  USB.println(F("------------------------------------------------------"));

  delay(1000);
}
