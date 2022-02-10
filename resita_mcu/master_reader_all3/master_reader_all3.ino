
#include <Wire.h>
char c;

void setup()
{
  Wire.begin(117);        // join I2C bus (address optional for master)
  Serial.begin(9600);  // start serial for output
  pinMode(LED_BUILTIN, OUTPUT);

}

void loop()
{
  /* Wire.requestFrom(8, 6);    // request 6 bytes from slave device #8

    while (Wire.available()) { // slave may send less than requested
    char c = Wire.read(); // receive a byte as character
    Serial.print(c);         // print the character
    }  */

  digitalWrite(LED_BUILTIN, LOW);
  //Wire.requestFrom(  0x19, 6);
  // c = Wire.read(); // receive a byte as character
  Serial.print("citire de pe  0x19:    ");
  Serial.println(Wire.read()  );
  delay(500);


  Serial.println(  "---------------------------------------"  );

}
