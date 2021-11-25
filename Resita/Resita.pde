//#include <WaspSensorGas_Pro.h>
#include <WaspSensorGas_v30.h>
#include <WaspUtils.h>
#include <WaspSensorPrototyping_v20.h>




int cycle_time2 = 120; // in seconds
unsigned long prev, b ;

#define RED_LED DIGITAL8
#define YELLOW_LED DIGITAL7



float concentration;  // Stores the concentration level in ppm
float temperature;  // Stores the temperature in C
float humidity;   // Stores the realitve humidity in %RH
float pressure;   // Stores the pressure in Pa



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


// asta e folosita in void loop la inceput de tott
void Watchdog_setup_and_reset(int x, bool y = false) // x e timpul in secunde  iar y e enable
{
  int tt;

  if ( y)
  {
    tt = 3 * x % 60;
    if (tt > 59)  // 59 minutes max timer time
    {
      tt = 59;
    }
    if (tt < 1)
    {
      tt = 1;   // 1 minute is min timer time
    }
    RTC.setWatchdog(tt);
    USB.print(F("RTC timer reset succesful"));
    USB.print(F("        next forced restart: "));
    USB.println(  RTC.getWatchdog()  );
  }

}






void setup()
{
  // Open the USB connection
  USB.ON();
  RTC.ON();
  USB.println(F("USB port started..."));
  pinMode(RED_LED, OUTPUT);
  pinMode(YELLOW_LED, OUTPUT);




  O2Sensor.setCalibrationPoints(voltages, concentrations);
  Gases.ON();
  // Switch ON the SOCKET_1
  O2Sensor.ON();
  // Switch ON the sensor socket

  PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  // asta vine in void setup
USB.println(F("Watchdog settings: 3 cycle time"));
Watchdog_setup_and_reset( cycle_time2, true);

}




void loop()
{
  prev = millis();
  Watchdog_setup_and_reset( cycle_time2, true);


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

      digitalWrite(RED_LED, HIGH);
    }
    else
    {
      // buzz+  yellow led
      digitalWrite(YELLOW_LED, HIGH);
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
