#include <WaspSensorGas_Pro.h>
#include <WaspUtils.h>

/*
   Define object for sensor: gas_PRO_sensor
   Input to choose board socket.
   Waspmote OEM. Possibilities for this sensor:
     - SOCKET_1
    - SOCKET_2
    - SOCKET_3
    - SOCKET_4
    - SOCKET_5
    - SOCKET_6
   P&S! Possibilities for this sensor:
    - SOCKET_A
    - SOCKET_B
    - SOCKET_C
    - SOCKET_F
*/

// 7 si 8 pt socket F
//3 4 pt socket C
#define RED_LED DIGITAL3
#define YELLOW_LED DIGITAL4




Gas gas_PRO_sensor(SOCKET_B);

float concentration;  // Stores the concentration level in ppm
float temperature;  // Stores the temperature in ºC
float humidity;   // Stores the realitve humidity in %RH
float pressure;   // Stores the pressure in Pa



int prag1 = 22.5;
int prag2 = 23.5;
int cycle_time2 = 120; // in seconds
unsigned long prev, b;
float O2Vol, O2Val;







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

  USB.println(F("Electrochemical gas sensor example"));

  ///////////////////////////////////////////
  // 1. Turn on the sensors
  ///////////////////////////////////////////

  // Power on the electrochemical sensor.
  // If the gases PRO board is off, turn it on automatically.
  gas_PRO_sensor.ON();

  // First sleep time
  // After 2 minutes, Waspmote wakes up thanks to the RTC Alarm
 // PWR.deepSleep("00:00:02:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  PWR.deepSleep("00:00:03:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
 // Watchdog_setup_and_reset( 4*60, true);
}

void loop()
{

  prev = millis();
 // Watchdog_setup_and_reset( cycle_time2, true);
  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////

  // Read the electrochemical sensor and compensate with the temperature internally
  concentration = gas_PRO_sensor.getConc();

  // Read enviromental variables
  temperature = gas_PRO_sensor.getTemp();
  humidity = gas_PRO_sensor.getHumidity();
  pressure = gas_PRO_sensor.getPressure();

  // And print the values via USB
  USB.println(F("***************************************"));
  USB.print(F("Gas concentration: "));
  USB.print(concentration);
  USB.println(F(" ppm"));


  O2Val = concentration / 10000;
  USB.print(F("Gas concentration: "));
  USB.print(O2Val);
  USB.println(F(" %"));
  USB.print(F("Temperature: "));
  USB.print(temperature);
  USB.println(F(" Celsius degrees"));
  USB.print(F("RH: "));
  USB.print(humidity);
  USB.println(F(" %"));
  USB.print(F("Pressure: "));
  USB.print(pressure);
  USB.println(F(" Pa"));

  // Show the remaining battery level
  USB.print(F("Battery Level: "));
  USB.print(PWR.getBatteryLevel(), DEC);
  USB.print(F(" %"));

  // Show the battery Volts
  USB.print(F(" | Battery (Volts): "));
  USB.print(PWR.getBatteryVolts());
  USB.println(F(" V"));






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








  ///////////////////////////////////////////
  // 5. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 2 minutes, Waspmote wakes up thanks to the RTC Alarm
  //  PWR.deepSleep("00:00:00:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);






  b = cycle_time2 * 1000 - ( millis() - prev );
  if ( b < 1)
  {
    b = 0;
  }
  delay(b);
}
