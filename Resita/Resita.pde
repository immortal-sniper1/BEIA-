//#include <WaspSensorGas_Pro.h>
#include <WaspSensorGas_v30.h>
#include <WaspUtils.h>
#include <WaspSensorPrototyping_v20.h>




int cycle_time2 = 2; // in seconds
unsigned long prev, b ;





float concentration;	// Stores the concentration level in ppm
float temperature;	// Stores the temperature in C
float humidity;		// Stores the realitve humidity in %RH
float pressure;		// Stores the pressure in Pa



// O2 Sensor must be connected in SOCKET_1
O2SensorClass O2Sensor(SOCKET_1);

// Percentage values of Oxygen
#define POINT1_PERCENTAGE 0.0
#define POINT2_PERCENTAGE 5.0

// Calibration Voltage Obtained during calibration process (in mV)
#define POINT1_VOLTAGE 0.35
#define POINT2_VOLTAGE 2.0

float concentrations[] = {POINT1_PERCENTAGE, POINT2_PERCENTAGE};
float voltages[] =       {POINT1_VOLTAGE, POINT2_VOLTAGE};
float O2Vol, O2Val;

int prag1 = 22.5;
int prag2 = 23.5;



//  https://www.electronicwings.com/users/sanketmallawat91/projects/215/frequency-changing-of-pwm-pins-of-arduino-uno

void setup()
{
  // Open the USB connection
  USB.ON();
  RTC.ON();
  USB.println(F("USB port started..."));
  // pinMode(DIGITAL4, OUTPUT);
  // pinMode(DIGITAL5, OUTPUT);
  //  pinMode(ANALOG4, OUTPUT);
  pinMode(DIGITAL19, OUTPUT);
  pinMode(ANALOG7, OUTPUT);
  //  digitalWrite(DIGITAL4, LOW);
  //  digitalWrite(DIGITAL5, LOW);
  //  digitalWrite(ANALOG4, LOW);



  O2Sensor.setCalibrationPoints(voltages, concentrations);
  Gases.ON();
  // Switch ON the SOCKET_1
  O2Sensor.ON();
  // Switch ON the sensor socket

  //PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  PWR.setSensorPower(SENS_5V, SENS_ON);



}









void loop()
{
  //digitalWrite(ANALOG20, HIGH);
  digitalWrite(DIGITAL19, HIGH);
  digitalWrite(ANALOG7, HIGH);

  prev = millis();


  O2Vol = O2Sensor.readVoltage();
  USB.print(F("O2 concentration Estimated: "));
  USB.print(O2Vol);
  USB.print(F(" mV | "));
  delay(100);

  // Read the concentration value in %
  O2Val = O2Sensor.readConcentration();

  USB.print(F(" O2 concentration Estimated: "));
  USB.print(O2Val * 0.6);
  USB.println(F(" %"));



  if ( O2Val > prag1 )
  {
    if ( O2Val > prag2 )
    {
      // buzz+ red led

      digitalWrite(DIGITAL19, HIGH);
    }
    else
    {
      // yellow led
      digitalWrite(ANALOG7, HIGH);
    }
  }


  b = cycle_time2 * 1000 - ( millis() - prev );
  if ( b < 1)
  {
    b = 0;
  }
  delay(b);
}








/*

  #include <WaspUtils.h>
  #include <WaspSensorPrototyping_v20.h>

  void setup()
  {
  pinMode(DIGITAL4, OUTPUT);
  pinMode(ANALOG4, OUTPUT);
   PWR.setSensorPower(SENS_3V3, SENS_ON);
   PWR.setSensorPower(SENS_5V, SENS_ON);
  }
  void loop()
  {
  // put your main code here, to run repeatedly:
  digitalWrite(DIGITAL4, HIGH);
  digitalWrite(ANALOG4, HIGH);
  Utils.setLED( LED0, LED_ON); // Sets the red LED ON
  delay(10000);
  digitalWrite(DIGITAL4, LOW);
  digitalWrite(ANALOG4, LOW);
  Utils.setLED( LED0, LED_OFF); // Sets the red LED OFF

  delay(10000);

  }




*/
