
uint8_t data_read;
int ss;

void setup()
{
  //////////////////////////
  // 1. Start the I2C bus
  //////////////////////////
  I2C.begin();


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
  I2C.write(0x70, 0xD1, 0x0D);
  USB.println(F("sa scris 13"));

  ss = 1* ( random( ) %100 );
  I2C.write(0x70, 0xD1, 't');
  USB.print(F("sa scris "));
  USB.println(ss);
  delay(1000);
}
