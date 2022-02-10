//https://development.libelium.com/ut-13-i2c/
uint8_t data_read;
int ss;

void setup()
{
  //////////////////////////
  // 1. Start the I2C bus
  //////////////////////////
  PWR.setSensorPower(SENS_3V3, SENS_ON);




}

void loop()
{


  /////////////////////////////////////////////////////////////
  // 3. Write data in the address register of the slave device
  /////////////////////////////////////////////////////////////
  // 0x77 -> slave device address
  // 0xD1 -> register address where data is written
  // 0x01 -> data stored into the register address of the device
  // daca vrem sa trimitem 13 atunci 0x0D
  // adresa la noi este variabila dar am pus o ca 0x70

  I2C.begin();
  I2C.write(117, 0x1, 0x00);
  USB.println(F("sa scris 13"));

  ss = 0.25 * ( random( ) % 100  );
  I2C.write(0x75, 0x50, ss);
  USB.print(F("sa scris "));
  USB.println(ss);
  I2C.close();
  delay(1000);
}
