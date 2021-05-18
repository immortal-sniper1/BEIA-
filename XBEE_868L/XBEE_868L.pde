#include <WaspSensorGas_Pro.h>
#include <WaspPM.h>
#include <WaspXBee868LP.h>
#include <WaspFrame.h> 

/*
   Define objects for sensors
   Imagine we have a P&S! with the next sensors:
    - SOCKET_A: sensor (CO2) 
    - SOCKET_B: sensor (NO2)
    - SOCKET_C: sensor (O3)
    - SOCKET_D: Particle matter sensor (dust)
    - SOCKET_E: BME280 sensor (temperature, humidity & pressure)
    - SOCKET_F: sensor (SO2)
*/

// Destination MAC address
// MAC LOW = 41C3ADE5 
//////////////////////////////////////////
char RX_ADDRESS[] = "0013A20041C3ADE5";
//////////////////////////////////////////



// define variable
uint8_t error;

Gas CO2(SOCKET_A);
Gas NO2(SOCKET_B);
Gas O3(SOCKET_C);
Gas SO2(SOCKET_F);

float temperature;
float humidity;
float pressure;

float concCO2;
float concNO2;
float concSO2;
float concO3;

int OPC_status;
int OPC_measure;

char node_ID[] = "SEP1";

// PAN (Personal Area Network) Identifier
uint8_t  panID[2] = {0x7F,0xFF}; 

// Define Freq Channel to be set: 
uint8_t  mask[4] = {0x3F,0xFF,0xFF,0xFF};

// Define preamble ID
uint8_t preambleID = 0x00;

// Define the Encryption mode: 1 (enabled) or 0 (disabled)
uint8_t encryptionMode = 0;

// Define the AES 16-byte Encryption Key
char  encryptionKey[] = "WaspmoteLinkKey!"; 




void XXBEE()
{
    // init XBee 
  xbee868LP.ON( SOCKET1 );  
  /////////////////////////////////////
  // 1. set channel 
  /////////////////////////////////////
  xbee868LP.setChannelMask( mask );

  // check at commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("1. Channel set OK to: 0x"));
    USB.printHex( xbee868LP._channelMask[0] );
    USB.printHex( xbee868LP._channelMask[1] );
    USB.printHex( xbee868LP._channelMask[2] );
    USB.printHex( xbee868LP._channelMask[3] );
    USB.println();
  }
  else 
  {
    USB.println(F("1. Error calling 'setChannel()'"));
  }


  /////////////////////////////////////
  // 2. set PANID
  /////////////////////////////////////
  xbee868LP.setPAN( panID );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("2. PAN ID set OK to: 0x"));
    USB.printHex( xbee868LP.PAN_ID[0] ); 
    USB.printHex( xbee868LP.PAN_ID[1] ); 
    USB.println();
  }
  else 
  {
    USB.println(F("2. Error calling 'setPAN()'"));  
  }

  /////////////////////////////////////
  // 3. set preamble ID
  /////////////////////////////////////
  xbee868LP.setPreambleID( preambleID );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("2. Preamble ID set OK to: 0x"));
    USB.printHex( xbee868LP._preambleID );
    USB.println();
  }
  else 
  {
    USB.println(F("2. Error calling 'setPreambleID()'"));  
  }

  /////////////////////////////////////
  // 4. set encryption mode (1:enable; 0:disable)
  /////////////////////////////////////
  xbee868LP.setEncryptionMode( encryptionMode );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("3. AES encryption configured (1:enabled; 0:disabled):"));
    USB.println( xbee868LP.encryptMode, DEC );
  }
  else 
  {
    USB.println(F("3. Error calling 'setEncryptionMode()'"));
  }

  /////////////////////////////////////
  // 5. set encryption key
  /////////////////////////////////////
  xbee868LP.setLinkKey( encryptionKey );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.println(F("4. AES encryption key set OK"));
  }
  else 
  {
    USB.println(F("4. Error calling 'setLinkKey()'")); 
  }

  /////////////////////////////////////
  // 6. write values to XBee module memory
  /////////////////////////////////////
  xbee868LP.writeValues();

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.println(F("5. Changes stored OK"));
  }
  else 
  {
    USB.println(F("5. Error calling 'writeValues()'"));   
  }

  USB.println(F("-------------------------------")); 

  // store Waspmote identifier in EEPROM memory
  frame.setID( node_ID );
}






void setup()
{
//    USB.ON();
//    USB.println("Frame Utility Example for Gases Pro Sensor Board");
//    USB.println("Sensors used:"));
//    USB.println("- SOCKET_A: Electrochemical gas sensor (C2)"");
//    USB.println("- SOCKET_B: Electrochemical gas sensor (NO2)");
//    USB.println("- SOCKET_C: Electrochemical gas sensor (O3)");
//    USB.println("- SOCKET_D: Particle matter sensor (dust)");
//    USB.println("- SOCKET_E: BME280 sensor (temperature, humidity & pressure)");
//    USB.println("- SOCKET_F: Electrochemical gas sensor (SO2)");

    
   // open USB port
  USB.ON();

  USB.println(F("-------------------------------"));
  USB.println(F("Configure XBee 868LP"));
  USB.println(F("-------------------------------"));

XXBEE();

}


void loop()
{
  //fffff
}








