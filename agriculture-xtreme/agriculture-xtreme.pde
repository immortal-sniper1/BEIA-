


//sensors
// Conductivity, water content and soil temperature 5TE sensor probe (Decagon 5TE)
//   https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#conductivity-water-content-and-soil-temperature-5te-sensor-probe-decagon-5te


// (Meter ATMOS 14) Vapor pressure, humidity, temperature and air pressure sensor probe
// https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#meter-atmos-14-vapor-pressure-humidity-temperature-and-air-pressure-sensor-probe



#include <WaspSensorXtr.h>
#include <WaspFrame.h>


// 1. Declare an object for the sensor
Decagon_5TE mySensor1(XTR_SOCKET_A);
// 1. Declare an object for the sensor
ATMOS_14 mySensor2(XTR_SOCKET_A);





void setup()
{
  // put your setup code here, to run once:

}


void loop()
{
  // put your main code here, to run repeatedly:



  {
    // 1. Declare an object for the sensor
    Decagon_5TE mySensor1(XTR_SOCKET_A);

    // 2. Turn ON the sensor
    mySensor1.ON();

    // 3. Read the sensor. Values stored in class variables
    // Check complete code example for details
    mySensor1.read();

    // 4. Turn off the sensor
    mySensor1.OFF();
    // 4. Conversion of dielectric permittivity into Volumetric Water Content (VWC)
    // for mineral soil using Topp equation
    float VWC = ((4.3 * pow(10, -6) * pow(mySensor1.sensor5TE.dielectricPermittivity, 3))
                 - (5.5 * pow(10, -4) * pow(mySensor1.sensor5TE.dielectricPermittivity, 2))
                 + (2.92 * pow(10, -2) * mySensor1.sensor5TE.dielectricPermittivity)
                 - (5.3 * pow(10, -2))) * 100 ;

    // 5. Print information  USB.println(F("---------------------------"));  USB.println(F("5TE"));  USB.print(F("Dielectric Permittivity: "));
    USB.printFloat(mySensor1.sensor5TE.dielectricPermittivity, 2);
    USB.println();
    USB.print(F("Volumetric Water Content: "));
    USB.printFloat(VWC, 2);
    USB.println(F(" %VWC"));
    USB.print(F("Electrical Conductivity: "));
    USB.printFloat(mySensor1.sensor5TE.electricalConductivity, 2);
    USB.println(F(" dS/m"));
    USB.print(F("Soil temperature: "));
    USB.printFloat(mySensor1.sensor5TE.temperature, 1);
    USB.println(F(" degrees Celsius"));
    USB.println(F("---------------------------\n"));


  }


  {
    // 1. Declare an object for the sensor
    ATMOS_14 mySensor2(XTR_SOCKET_A);

    // 2. Turn ON the sensor
    mySensor2.ON();

    // 3. Read the sensor. Values stored in class variables
    // Check complete code example for details
    mySensor2.read();

    // 4. Turn off the sensor
    mySensor2.OFF();

    // 4. Print information
    USB.println(F("---------------------------"));
    USB.println(F("ATMOS 14"));
    USB.print(F("Vapor Pressure:"));
    USB.printFloat(mySensor2.sensorATMOS14.vaporPressure, 3);
    USB.println(F(" kPa"));
    USB.print(F("Temperature:"));
    USB.printFloat(mySensor2.sensorATMOS14.temperature, 1);
    USB.println(F(" degrees Celsius"));
    USB.print(F("Relative Humidity:"));
    USB.printFloat(mySensor2.sensorATMOS14.relativeHumidity, 1);
    USB.println(F(" %RH"));
    USB.print(F("Atmospheric Pressure:"));
    USB.printFloat(mySensor2.sensorATMOS14.atmosphericPressure, 2);
    USB.println(F(" kPa"));
    USB.println(F("---------------------------\n"));
  }







}
























































