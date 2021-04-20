#include <WaspXBeeZB.h>
#include <WaspFrame.h> 




// known coordinator's operating 64-bit PAN ID to set
////////////////////////////////////////////////////////////////////////
uint8_t  PANID[8] = {  "BE1A"  };
////////////////////////////////////////////////////////////////////////
// Destination MAC address
//////////////////////////////////////////
char RX_ADDRESS[] = "0013A200416CCA43";
//////////////////////////////////////////

// Define the Waspmote ID
char WASPMOTE_ID[] = "node_RKK";

// define variable
uint8_t error;











void setup()
{
  // open USB
  USB.ON();

  ///////////////////////////////////////////////
  // Init XBee
  ///////////////////////////////////////////////
  xbeeZB.ON();


  ///////////////////////////////////////////////
  // 1. Disable Coordinator mode
  ///////////////////////////////////////////////

  /*************************************
    WARNING: Only XBee ZigBee S2C and
    XBee ZigBee S2D are able to use
    this function properly
  ************************************/
  xbeeZB.setCoordinator(DISABLED);

  // check at command flag
  if (xbeeZB.error_AT == 0)
  {
    USB.println(F("1. Coordinator mode disabled"));
  }
  else
  {
    USB.println(F("1. Error while disabling Coordinator mode"));
  }
  

  ///////////////////////////////////////////////
  // 2. Set PANID
  ///////////////////////////////////////////////

  /*
  xbeeZB.setPAN(PANID);

  // check at command flag
  if (xbeeZB.error_AT == 0)
  {
    USB.println(F("2. PANID set OK"));
  }
  else
  {
    USB.println(F("2. Error while setting PANID"));
  }
*/

  ///////////////////////////////////////////////
  // 3. Set channels to be scanned before creating network
  ///////////////////////////////////////////////
  // channels from 0x0B to 0x18 (0x19 and 0x1A are excluded)
  /* Range:[0x0 to 0x3FFF]
    Channels are scpedified as a bitmap where depending on
    the bit a channel is selected --> Bit (Channel):
     0 (0x0B)  4 (0x0F)  8 (0x13)   12 (0x17)
     1 (0x0C)  5 (0x10)  9 (0x14)   13 (0x18)
     2 (0x0D)  6 (0x11)  10 (0x15)
     3 (0x0E)  7 (0x12)   11 (0x16)    */
 /* xbeeZB.setScanningChannels(0x12, 0x12);

  // check at command flag
  if (xbeeZB.error_AT == 0)
  {
    USB.println(F("3. Scanning channels set OK"));
  }
  else
  {
    USB.println(F("3. Error while setting 'Scanning channels'"));
  }
*/

  ///////////////////////////////////////////////
  // Save values
  ///////////////////////////////////////////////
  xbeeZB.writeValues();

  // wait for the module to set the parameters
  //delay(10000);
  USB.println();
    ///////////////////////////////
  // get network parameters
  ///////////////////////////////

  xbeeZB.getOperating16PAN();
  xbeeZB.getOperating64PAN();
  xbeeZB.getChannel();

  USB.print(F("operatingPAN: "));
  USB.printHex(xbeeZB.operating16PAN[0]);
  USB.printHex(xbeeZB.operating16PAN[1]);
  USB.println();

  USB.print(F("extendedPAN: "));
  USB.printHex(xbeeZB.operating64PAN[0]);
  USB.printHex(xbeeZB.operating64PAN[1]);
  USB.printHex(xbeeZB.operating64PAN[2]);
  USB.printHex(xbeeZB.operating64PAN[3]);
  USB.printHex(xbeeZB.operating64PAN[4]);
  USB.printHex(xbeeZB.operating64PAN[5]);
  USB.printHex(xbeeZB.operating64PAN[6]);
  USB.printHex(xbeeZB.operating64PAN[7]);
  USB.println();

  USB.print(F("channel: "));
  USB.printHex(xbeeZB.channel);
  USB.println();

}







void loop()
{



///////////////////////////////////////////
  // 1. Create ASCII frame
  ///////////////////////////////////////////  

  // create new frame
  frame.createFrame(ASCII);  
  
  // add frame fields
  frame.addSensor(SENSOR_STR, "new_sensor_frame");
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel()); 
  

  ///////////////////////////////////////////
  // 2. Send packet
  ///////////////////////////////////////////  

  // send XBee packet
  error = xbeeZB.send( RX_ADDRESS, frame.buffer, frame.length );   
  
  // check TX flag
  if( error == 0 )
  {
    USB.println(F("send ok"));
    
    // blink green LED
    Utils.blinkGreenLED();
    
  }
  else 
  {
    USB.println(F("send error"));
    
    // blink red LED
    Utils.blinkRedLED();
  }

  delay(1000);
/*
  error = xbeeZB.send( RX_ADDRESS, 'RKK13', 5 );   
  
  // check TX flag
  if( error == 0 )
  {
    USB.println(F("send ok"));
    
    // blink green LED
    Utils.blinkGreenLED();
    
  }
  else 
  {
    USB.println(F("send error"));
    
    // blink red LED
    Utils.blinkRedLED();
  }

  delay(1000);

  */




}
