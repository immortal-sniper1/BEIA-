#include <Wasp4G.h>

// APN settings
///////////////////////////////////////
char apn[] = "internet";
char login[] = "";
char password[] = "";
///////////////////////////////////////

uint8_t connection_status;
char operator_name[20];

uint8_t error;

void setup()
{
  USB.ON();
  USB.println(F("Start program\n"));
  
  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);

  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();
}


void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON the 4G module
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready"));

    ////////////////////////////////////////////////
    // 1.1. Check connection to network and continue
    ////////////////////////////////////////////////
    connection_status = _4G.checkDataConnection(60);
    
    if (connection_status == 0)
    {
      _4G.setTimeFrom4G();
      USB.println(RTC.getTime());
      USB.println(RTC.getTimestamp());
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }

  //////////////////////////////////////////////////
  // 2. Switch OFF the 4G module
  //////////////////////////////////////////////////
  _4G.OFF();
  USB.println(F("2. Switch OFF 4G module"));


  //////////////////////////////////////////////////
  // 3. Sleep
  //////////////////////////////////////////////////
  USB.println(F("3. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("4. Wake up!!\n\n"));

}
