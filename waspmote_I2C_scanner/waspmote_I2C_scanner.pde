
int x, y;

void setup()
{
  // put your setup code here, to run once:
  PWR.setSensorPower(SENS_3V3, SENS_ON);

}


void loop()
{
  // put your main code here, to run repeatedly:
  I2C.secureBegin();
  USB.println(F("start of I2C scann process"));
  for ( x = 0; x < 1024; x++)
  {
    if (  !I2C.scan( x) )
    {
      y = 1;
      USB.print(F("status on:"));
      USB.print(x);
      USB.print(F(" "));
      USB.println(y);
    }
    else
    {
      y = 0;
    }

  }


  I2C.close();
  USB.println(F("end of I2C scann process"));
  delay(1000000);

}
