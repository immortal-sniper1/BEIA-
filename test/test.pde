//#include <WaspSensorGas_Pro.h>
#include <WaspSensorGas_v30.h>
#include <WaspUtils.h>
#include <WaspSensorPrototyping_v20.h>




int cycle_time2 = 120; // in seconds
unsigned long prev, b ;


// 7 si 8 pt socket F
//3 4 pt socket C
#define RED_LED DIGITAL3
#define YELLOW_LED DIGITAL4







void setup()
{
  // Open the USB connection
  USB.ON();
  RTC.ON();
  USB.println(F("USB port started..."));
  pinMode(RED_LED, OUTPUT);
  pinMode(YELLOW_LED, OUTPUT);
  digitalWrite(RED_LED, LOW);
  digitalWrite(YELLOW_LED, LOW);
  delay(1000);
}



void loop()
{


  // buzz+ red led

  digitalWrite(RED_LED, HIGH);
  USB.println(F("RED ON"));
  delay(5000);
  digitalWrite(RED_LED, LOW);
  USB.println(F("RED OFF"));
  delay(10000);



  // buzz+  yellow led
  digitalWrite(YELLOW_LED, HIGH);
  USB.println(F("YELLOW ON"));
  delay(5000);
  digitalWrite(YELLOW_LED, LOW);
  USB.println(F("YELLOW OFF"));







  delay(10000);
  digitalWrite(YELLOW_LED, HIGH);
  digitalWrite(RED_LED, HIGH);
  USB.println(F("RED ON"));
  USB.println(F("YELLOW ON"));
  delay(5000);
  digitalWrite(RED_LED, LOW);
  digitalWrite(YELLOW_LED, LOW);
  USB.println(F("YELLOW OFF"));
  USB.println(F("RED OFF"));
  delay(100000);
}





