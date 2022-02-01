#include <Wire.h>

byte x = 0;

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);
  Serial.print("start");
}


void loop()
{

  Wire.beginTransmission(4); // transmit to device #4
  Serial.print("loop x:");
  Serial.println(x);
  Wire.write(x);
  Wire.endTransmission();    // stop transmitting
  x++;

  delay(5000);

}
