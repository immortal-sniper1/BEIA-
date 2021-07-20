#include <WaspSensorPrototyping_v20.h>


int val2 = 0;


void setup()
{
  //PWR.setSensorPower(SENS_3V3, SENS_ON);   // power sensor on
  // PWR.setSensorPower(SENS_5V, SENS_ON);   // power sensor on


  pinMode(DIGITAL8, OUTPUT); // Sets DIGITAL4 as an output
  digitalWrite(DIGITAL8, HIGH); // Writes 'High' to Digital 4

   //pinMode(DIGITAL7, OUTPUT); // Sets DIGITAL4 as an output
   //digitalWrite(DIGITAL7, HIGH); // Writes 'High' to Digital 3



  // pinMode(ANA2, OUTPUT); // Sets DIGITAL4 as an output
  //digitalWrite(ANA2, HIGH); // Writes 'High' to analog 2


   pinMode(ANALOG5, INPUT); // Sets DIGITAL1 as an input



}


void loop()
{



  val2 = analogRead(ANALOG5);     // pin 6 pt pcb diy
  USB.print(F("  ||    ANALOG: "));
  USB.println(val2);
  delay(1000);


}

