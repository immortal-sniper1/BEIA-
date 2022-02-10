#include <Wire.h>

const int slaveAddress = 0x70;

const int ledRed = LED_BUILTIN;      // LED connected to digital pin 2
const int ledYell = 3;      // LED connected to digital pin 3
const int buzz = 5;        // buzzer connected to digital pin 5
int safety = 7;
int c;
void setup()
{
  Wire.begin();        // join i2c bus (address optional for master)
  Serial.begin(9600);  // start serial for output
  Serial.println("start");
  pinMode(ledRed, OUTPUT);
  pinMode(ledYell, OUTPUT);
  pinMode(buzz, OUTPUT);
  pinMode(safety, OUTPUT);

}




void loop()
{
  Wire.requestFrom(  slaveAddress , 1);    // request 2 bytes from peripheral device #8
  Serial.println("loop n");
  // while ( Wire.available() )   // peripheral may send less than requested


  //  c = Wire.read(); // receive a byte as character
  // Serial.println(c , HEX);         // print the character



  // c = Wire.read(); // receive a byte as character
  // Serial.println(c, HEX);         // print the character
  Serial.println(  Wire.read() , HEX);
  Serial.println(  Wire.read() , HEX);

  /*

      if ( c == 13 )     // 13 si 46 sunt la intamplare
      {
        digitalWrite(ledRed, HIGH);
        digitalWrite(buzz, HIGH);
        Serial.println("primit 13");
      }
      if ( c == 46 )
      {
        digitalWrite(ledYell, HIGH);
        digitalWrite( buzz, HIGH);
      }
      else
      {
        Serial.println("invalid command!");
      }

  */

  delay(1000);
  digitalWrite(ledRed, LOW);
  digitalWrite(ledYell, LOW);
  digitalWrite(buzz, LOW);
}
