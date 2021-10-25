#include <WaspSensorXtr.h>
#include <WaspFrame.h>
#include <Wasp4G.h>

//sensors
// Conductivity, water content and soil temperature 5TE sensor probe (Decagon 5TE)
//   https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#conductivity-water-content-and-soil-temperature-5te-sensor-probe-decagon-5te


// (Meter ATMOS 14) Vapor pressure, humidity, temperature and air pressure sensor probe
// https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#meter-atmos-14-vapor-pressure-humidity-temperature-and-air-pressure-sensor-probe


// Leaf wetness Phytos 31 sensor probe (Decagon Phytos 31)
// https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#leaf-wetness-phytos-31-sensor-probe-decagon-phytos-31


// Soil oxygen level sensor probe (Apogee SO-411 & SO-421)
// https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#soil-oxygen-level-sensor-probe-apogee-so-411-and-so-421


// Solar radiation sensor probe for Smart Agriculture Xtreme (Apogee SQ-110)
// https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#solar-radiation-sensor-probe-for-smart-agriculture-xtreme-apogee-sq-110

// Weather station sensor probe MaxiMet GMX-240 (W-PO) sensor probe
// https://development.libelium.com/smart-agriculture-xtreme-sensor-guide/sensors-probes#maximet-gmx-240-w-po-sensor-probe









//NU UNBLA AICI!!
// define variable SD
// define file name: MUST be 8.3 SHORT FILE NAME
char filename[] = "FILE1.TXT";
int loop_count;
char *time_date; // stores curent date + time
int cycle_time, x, b;
uint8_t error, status = false;
char y[3];
uint8_t sd_answer, ssent = 0, resend_f = 2; // frame resend atempts
bool sentence = false; // true for deletion on reboot  , false for data appended to end of file
bool IRL_time = false; //  true for no external data source
char rtc_str[] = "00:00:00:05";    // 11 char ps incepe de la 0
unsigned long prev, previous;
bool RTC_SUCCES = false;

char programID[10];
// SERVER settings
///////////////////////////////////////
char host[] = "82.78.81.178";
uint16_t port = 80;
///////////////////////////////////////

///////////////////////////////////////
//FTP send
char SD_FILE[]     = "FILE1.TXT";
char SERVER_FILE[] = "HHKFILE2.TXT";
uint8_t connection_status, net_in_attempt;
char operator_name[20];
uint8_t program_verrr;


//EDITEAZA AICI!
int  cycle_time2 = 1150; // in seconds
char node_ID[] = "agro xtreme";
uint8_t RTC_ATEMPTS = 10; // number of RTC sync atempts
// APN settings
///////////////////////////////////////    pt orange RO
char apn[] = "net";
char login[] = "";
char password[] = "";
///////////////////////////////////////
// FTP SERVER settings
///////////////////////////////////////
char ftp_server[] = "ftp.agile.ro";
uint16_t ftp_port = 21;
char ftp_user[] = "folderone@agile.ro";
char ftp_pass[] = "1fENXK~0qMgw";








////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///senzori declarari

//[Sensor Class] [Sensor Name] [Selected socket]

// 1. Declare an object for the sensor
Decagon_5TE mySensor1(XTR_SOCKET_A);                      // A B C D
// 1. Declare an object for the sensor
leafWetness mySensor3();                                 // asta vine doar in socket B    WTF de de nu merge cu declarare aici?!
// 1. Declare an object for the sensor
Decagon_VP4 mySensor2(XTR_SOCKET_C);                        // A B C D
// 1. Declare an object for the sensor
Apogee_SO411 mySensor4(XTR_SOCKET_D);                    // A B C D
//   [Sensor Class] [Sensor Name]
weatherStation mySensor6;                                // asta vine doar in socket E
// 1. Declare an object for the sensor
Apogee_SQ110 mySensor5 = Apogee_SQ110(XTR_SOCKET_F);     // B C E F



uint8_t response = 0;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// subprograme

void linie_de_X(uint8_t x = 1)
{
  for (uint8_t i = 0; i < x ; i++)
  {
    USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
  }
}


void linie_de_minus(uint8_t x = 1) // astia de la libelium o folosesc mult de tot
{
  for (uint8_t i = 0; i < x ; i++)
  {
    linie_de_minus(1);
  }
}


void scriitor_SD(char filename_a2[], uint8_t ssent_a = 0)
{
  SD.ON();
  USB.println(F("scriitor SD  "));

  long int size, m;
  m = 104857600 ; //100MB file size
  //m= 1048576;    //10MB file size
  bool q = true;
  int i;
  char filename_a[13];





  for (i = 0; i < 12; i++)
  {
    filename_a[i] = filename_a2[i];
  }
  //USB.println(F("scriitor SD2"));


  i = 1;
fazuzu:
  size = SD.getFileSize( filename_a );
  if (  (size >= m)  )
  {
    i++;
    itoa(i, y , 10);

    if (i < 10)
    {
      filename_a[4] = y[0];
    }
    else if ( i >= 10 && i <= 99)
    {
      for (int t = 0; t < 4; t++)
      {
        filename_a[9 - t] = filename_a[8 - t];
      }
      filename_a[4] = y[0];
      filename_a[5] = y[1];
      filename_a[10] = '\0';


      /*
        USB.print(F("xxxxx"));
        USB.print(  filename_a  );
        USB.println(F("xxxxx"));
        USB.print(F("xxxxx"));
        USB.print(  strlen(  filename_a  ));
        USB.println(F("xxxxx"));

      */
    }
    else
    {

      if (i > 330)
      {
        i = 330; // pt ca exista o limita de fisiere in root si 330 a destul de sub limita sa nu faca probleme
      }
      for (int t = 0; t < 4; t++)
      {
        filename_a[10 - t] = filename_a[9 - t];
      }
      filename_a[4] = y[0];
      filename_a[5] = y[1];
      filename_a[6] = y[2];
      filename_a[11] = '\0';
    }

    goto  fazuzu;
  }
  //USB.println(F("scriitor SD4"));





  USB.print(F("se va scrie in: "));
  USB.println(filename_a);
  i = SD.create(filename_a);
  if (i == 1)
  {
    USB.println(F("file created since it was not present "));
  }






  int coruption = 0;
  //sd_answer = SD.appendln(filename_a, "am scris aici!!!!!!!!");
  //coruption = coruption + sd_answer;
  // now storeing it locally
  time_date = RTC.getTime();
  USB.print(F("time: "));
  USB.println(time_date);

  x = RTC.year;
  itoa(x, y, 10);
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }

  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption = coruption + sd_answer;
  x = RTC.month;
  itoa(x, y, 10);
  if (x < 10)
  {
    y[1] = y[0];
    y[0] = '0';
  }
  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption = coruption + sd_answer;
  x = RTC.date;
  itoa(x, y, 10);
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }
  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption = coruption + sd_answer;
  x = RTC.hour;
  itoa(x, y, 10);
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }
  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption = coruption + sd_answer;
  x = RTC.minute;
  itoa(x, y, 10);
  if (x < 10)
  {
    y[1] = y[0];
    y[0] = '0';
  }
  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption = coruption + sd_answer;
  x = RTC.second;
  itoa(x, y, 10);
  if (x < 10)
  {
    y[1] = y[0];
    y[0] = '0';
  }
  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, "  ");
  coruption = coruption + sd_answer;



  sd_answer = SD.append(filename_a, frame.buffer, frame.length);  // scriere propriuzisa frame
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, "  ");
  coruption = coruption + sd_answer;
  itoa(ssent_a, y, 10);
  sd_answer = SD.appendln(filename_a, y);
  coruption = coruption + sd_answer;
  // frame is stored

  SD.OFF();

  if (coruption == 15)
  {
    USB.println(F("SD storage done with no errors"));
  } else {
    USB.print(F("SD sorage done with:"));
    USB.print(15 - coruption);
    USB.println(F(" errors"));
  }
}



void data_maker( int x , char filename_a[]  )
{
  SD.ON();

  for (int ii = 1 ; ii <= x ; ii++) //10MB per x=1
  {
    USB.println(F(" cycles: "));
    USB.println(ii);
    USB.println(F("/"));
    USB.println(x);
    for (int g = 0; g < 324 ; g++)
    {
      SD.appendln(filename_a, " ");
      USB.println(F(" subcycles: "));
      USB.println(g);
      USB.println(F("/324"));
      for (int k = 0 ; k < 324 ; k++)
        SD.append(filename_a, "eokfumpwqroifv4478fcmwpocfumwqgif17nwqrpn5fcmwifcwuifw7unpcwogr2rqfcnqwogfqprwfmqwfhwdjfbplpkp13plo");   //100 byte per line
    }
  }
  SD.OFF();

}







void INFO_4G_MDD()
{
  int temperature;
  USB.ON();
  linie_de_X(1);
  USB.println(F("Start INFO_4G_MDD"));
  delay(5000);
  /////////////////////////////////////////////////
  // 1. Switch on the 4G module
  //////////////////////////////////////////////////
  error = _4G.ON();

  // check answer
  if (error == 0)
  {
    USB.println(F("4G module ready\n"));

    ////////////////////////////////////////////////
    // 1.1. Hardware revision
    ////////////////////////////////////////////////
    error = _4G.getInfo(Wasp4G::INFO_HW);
    if (error == 0)
    {
      USB.print(F("1.1. Hardware revision: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.println(F("1.1. Hardware revision ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.2. Manufacturer identification
    ////////////////////////////////////////////////
    error = _4G.getInfo(Wasp4G::INFO_MANUFACTURER_ID);
    if (error == 0)
    {
      USB.print(F("1.2. Manufacturer identification: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.println(F("1.2. Manufacturer identification ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.3. Model identification
    ////////////////////////////////////////////////
    error = _4G.getInfo(Wasp4G::INFO_MODEL_ID);
    if (error == 0)
    {
      USB.print(F("1.3. Model identification: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.println(F("1.3. Model identification ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.4. Revision identification
    ////////////////////////////////////////////////
    error = _4G.getInfo(Wasp4G::INFO_REV_ID);
    if (error == 0)
    {
      USB.print(F("1.4. Revision identification: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.println(F("1.4. Revision identification ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.5. Revision identification
    ////////////////////////////////////////////////
    error = _4G.getInfo(Wasp4G::INFO_IMEI);
    if (error == 0)
    {
      USB.print(F("1.5. IMEI: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.println(F("1.5. IMEI ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.6. IMSI
    ////////////////////////////////////////////////
    error = _4G.getInfo(Wasp4G::INFO_IMSI);
    if (error == 0)
    {
      USB.print(F("1.6. IMSI: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.println(F("1.6. IMSI ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.7. ICCID
    ////////////////////////////////////////////////
    error = _4G.getInfo(Wasp4G::INFO_ICCID);
    if (error == 0)
    {
      USB.print(F("1.7. ICCID: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.println(F("1.7. ICCID ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.8. Show APN settings
    ////////////////////////////////////////////////
    USB.println(F("1.8. Show APN:"));
    _4G.show_APN();

    ////////////////////////////////////////////////
    // 1.9. Get temperature
    ////////////////////////////////////////////////
    error = _4G.getTemp();
    if (error == 0)
    {
      USB.print(F("1.9a. Temperature interval: "));
      USB.println(_4G._tempInterval, DEC);
      USB.print(F("1.9b. Temperature: "));
      USB.print(_4G._temp, DEC);
      USB.println(F(" Celsius degrees"));
    }
    else
    {
      USB.println(F("1.9. Temperature ERROR"));
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("4G module not started"));
  }
  linie_de_X(1);
  USB.OFF();

}





void INFO_4G_NET()
{
  USB.ON();
  linie_de_X(1);
  USB.println(F("Starting INFO_4G_NET"));

  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);

  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();

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
    connection_status = _4G.checkDataConnection(30);

    if (connection_status == 0)
    {
      USB.println(F("1.1. Module connected to network"));

      // delay for network parameters stabilization
      delay(5000);

      //////////////////////////////////////////////
      // 1.2. Get RSSI
      //////////////////////////////////////////////
      error = _4G.getRSSI();
      if (error == 0)
      {
        USB.print(F("1.2. RSSI: "));
        USB.print(_4G._rssi, DEC);
        USB.println(F(" dBm"));
      }
      else
      {
        USB.println(F("1.2. Error calling 'getRSSI' function"));
      }

      //////////////////////////////////////////////
      // 1.3. Get Network Type
      //////////////////////////////////////////////
      error = _4G.getNetworkType();

      if (error == 0)
      {
        USB.print(F("1.3. Network type: "));
        switch (_4G._networkType)
        {
        case Wasp4G::NETWORK_GPRS:
          USB.println(F("GPRS"));
          break;
        case Wasp4G::NETWORK_EGPRS:
          USB.println(F("EGPRS"));
          break;
        case Wasp4G::NETWORK_WCDMA:
          USB.println(F("WCDMA"));
          break;
        case Wasp4G::NETWORK_HSDPA:
          USB.println(F("HSDPA"));
          break;
        case Wasp4G::NETWORK_LTE:
          USB.println(F("LTE"));
          break;
        case Wasp4G::NETWORK_UNKNOWN:
          USB.println(F("Unknown or not registered"));
          break;
        }
      }
      else
      {
        USB.println(F("1.3. Error calling 'getNetworkType' function"));
      }

      //////////////////////////////////////////////
      // 1.4. Get Operator name
      //////////////////////////////////////////////
      memset(operator_name, '\0', sizeof(operator_name));
      error = _4G.getOperator(operator_name);

      if (error == 0)
      {
        USB.print(F("1.4. Operator: "));
        USB.println(operator_name);
      }
      else
      {
        USB.println(F("1.4. Error calling 'getOperator' function"));
      }
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
  linie_de_X(1);
  USB.OFF();

}




void HTTP_GET_4G()
{
  // SERVER settings
  ///////////////////////////////////////
  char host[] = "test.libelium.com";
  uint16_t port = 80;
  char resource[] = "/test-get-post.php?varA=1&varB=2&varC=3&varD=4&varE=5&varF=6&varG=7&varH=8&varI=9&varJ=10&varK=11&varL=12&varM=13&varN=14&varO=15";
  ///////////////////////////////////////

  linie_de_X(1);
  USB.println(F("STARTING HTTP_GET_4G"));
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));


    ////////////////////////////////////////////////
    // 2. HTTP GET
    ////////////////////////////////////////////////

    USB.print(F("2. Getting URL with GET method..."));

    // send the request
    error = _4G.http( Wasp4G::HTTP_GET, host, port, resource);

    // Check the answer
    if (error == 0)
    {
      USB.print(F("Done. HTTP code: "));
      USB.println(_4G._httpCode);
      USB.print(F("Server response: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.print(F("Failed. Error code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }


  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("3. Switch OFF 4G module"));
  _4G.OFF();
  linie_de_X(1);
}


void HTTP_POST_4G()
{
  // SERVER settings
  ///////////////////////////////////////
  char host[] = "test.libelium.com";
  uint16_t port = 80;
  char resource[] = "/test-get-post.php";
  char data[] = "varA=1&varB=2&varC=3&varD=4&varE=5";
  ///////////////////////////////////////

  USB.ON();
  USB.println(F("Starting program HTTP_POST_4G"));

  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();


  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));


    ////////////////////////////////////////////////
    // 2. HTTP POST
    ////////////////////////////////////////////////

    USB.print(F("2. HTTP POST request..."));

    // send the request
    error = _4G.http( Wasp4G::HTTP_POST, host, port, resource, data);

    // check the answer
    if (error == 0)
    {
      USB.print(F("Done. HTTP code: "));
      USB.println(_4G._httpCode);
      USB.print(F("Server response: "));
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.print(F("Failed. Error code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }

  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("3. Switch OFF 4G module"));
  //_4G.enterPIN("0000");    // pt oranege

  _4G.OFF();


}








int HTTP_4G_TRIMITATOR_FRAME()
{

  int ssent = 0;
  int ssent2;
  // nu se trimite daca bateria e prea descarcata
  if ( PWR.getBatteryLevel() >= 50 )
  {
    goto gato;
  }
  else
  {
    if ( PWR.getBatteryLevel() >= 30 )
    {
      if ( loop_count % 2 == 0)
      {
        goto gato;
      }
    }
    else
    {
      if ( (PWR.getBatteryLevel() >= 20 ) && ( loop_count % 4 == 0)   )
      {
        goto gato;
      }
    }
  }

  USB.println(F("Not sending data due to low battery levels BUT DATA IS STORED ON THE SD CARD"));
  goto not_sendeder;
gato:


  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    ////////////////////////////////////////////////
    // 3. Send to Meshlium
    ////////////////////////////////////////////////
    USB.print(F("Sending the frame..."));
    error = _4G.sendFrameToMeshlium( host, port, frame.buffer, frame.length);

    // check the answer
    if ( error == 0)
    {
      USB.print(F("Done. HTTP code: "));
      USB.println(_4G._httpCode);
      USB.print(F("Server response: "));
      USB.println(_4G._buffer, _4G._length);
      ssent2 = _4G._httpCode;
      if ( ssent2 == 200)
      {
        ssent = 1;
      }
      else
      {
        ssent = 0;
      }
    }
    else
    {
      USB.print(F("Failed. Error code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }


  ////////////////////////////////////////////////
  // 4. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("4. Switch OFF 4G module"));
  _4G.OFF();
not_sendeder:
  return ssent;
}











void SET_RTC_4G( int g = 2) // 2 pt GMT+2 adica ora Romaniei
{
  USB.println(F(" "));
  USB.println(F(" "));
  USB.println(F(" "));
  USB.println(F(" "));
  USB.println(F("START OF THE RTC SEGMENT"));
  //////////////////////////////////////////////////
  // 1. Switch ON the 4G module
  //////////////////////////////////////////////////
kyuubi:
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
      USB.println(F("CURENT TIME:"));
      USB.println(RTC.getTime());
      USB.println(RTC.getTimestamp());
      RTC_SUCCES = true;
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
    x++;
    if (x <= g)
    {
      goto kyuubi;
    }

  }

  //////////////////////////////////////////////////
  // 2. Switch OFF the 4G module
  //////////////////////////////////////////////////
  _4G.OFF();
  USB.println(F("2. Switch OFF 4G module"));
}



void IN_LOOP_RTC_CHECK( bool S)
{
  if (  (S = false) || (intFlag & RTC_INT)   )
  {
    SET_RTC_4G();
  }
}






//printError - prints the error related to OTA

void printErrorxx(uint8_t err)
{
  switch (err)
  {
  case 1:  USB.println(F("SD not present"));
    break;
  case 2:  USB.println(F("error downloading UPGRADE.TXT"));
    break;
  case 3:  USB.println(F("error opening FTP session"));
    break;
  case 4:  USB.println(F("filename is different to 7 bytes"));
    break;
  case 5:  USB.println(F("no 'FILE' pattern found"));
    break;
  case 6:  USB.println(F("'NO_FILE' is the filename"));
    break;
  case 7:  USB.println(F("no 'PATH' pattern found"));
    break;
  case 8:  USB.println(F("no 'SIZE' pattern found"));
    break;
  case 9:  USB.println(F("no 'VERSION' pattern found"));
    break;
  case 10: USB.println(F("invalid program version number"));
    break;
  case 11: USB.println(F("file size does not match in UPGRADE.TXT and server"));
    break;
  case 12: USB.println(F("error downloading binary file: server file size is zero"));
    break;
  case 13: USB.println(F("error downloading binary file: reading the file size"));
    break;
  case 14: USB.println(F("error downloading binary file: SD not present"));
    break;
  case 15: USB.println(F("error downloading binary file: error creating the file in SD"));
    break;
  case 16: USB.println(F("error downloading binary file: error opening the file"));
    break;
  case 17: USB.println(F("error downloading binary file: error setting the pointer of the file"));
    break;
  case 18: USB.println(F("error downloading binary file: error opening the GET connection"));
    break;
  case 19: USB.println(F("error downloading binary file: error module returns error code after requesting data"));
    break;
  case 20: USB.println(F("error downloading binary file: error  getting packet size"));
    break;
  case 21: USB.println(F("error downloading binary file: packet size mismatch"));
    break;
  case 22: USB.println(F("error downloading binary file: error writing SD"));
    break;
  case 23: USB.println(F("error downloading binary file: no more retries getting data"));
    break;
  case 24: USB.println(F("error downloading binary file: size mismatch"));
    break;
  default : USB.println(F("unknown"));

  }
}





void OTAP_4G()
{
  USB.println(F("STARTING OTAP VERSION CHECK"));
  //////////////////////////////
  // 4.1. Switch ON
  //////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    //////////////////////////////
    // 4.3. Request OTA
    //////////////////////////////
    USB.println(F("==> Request OTA..."));
    error = _4G.requestOTA(ftp_server, ftp_port, ftp_user, ftp_pass);

    if (error != 0)
    {
      USB.print(F("OTA request failed. Error code: "));
      printErrorxx(error);
    }

    // blink RED led
    Utils.blinkRedLED(300, 3);

  }
  else
  {
    USB.println(F("4G module not started"));
  }

  USB.println(F("5. Switch OFF 4G module"));
  _4G.OFF();

}



void FTP_4G_SEND(char SD_FILE[] , char SERVER_FILE[])
{
  int previous;
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    ////////////////////////////////////////////////
    // 2.1. FTP open session
    ////////////////////////////////////////////////

    error = _4G.ftpOpenSession(ftp_server, ftp_port, ftp_user, ftp_pass);

    // check answer
    if (error == 0)
    {
      USB.println(F("2.1. FTP open session OK"));

      previous = millis();

      //////////////////////////////////////////////
      // 2.2. FTP upload
      //////////////////////////////////////////////

      error = _4G.ftpUpload(SERVER_FILE, SD_FILE);

      if (error == 0)
      {

        USB.print(F("2.2. Uploading SD file to FTP server done! "));
        USB.print(F("Upload time: "));
        USB.print((millis() - previous) / 1000, DEC);
        USB.println(F(" s"));
      }
      else
      {
        USB.print(F("2.2. Error calling 'ftpUpload' function. Error: "));
        USB.println(error, DEC);
      }

      //////////////////////////////////////////////
      // 2.3. FTP close session
      //////////////////////////////////////////////

      error = _4G.ftpCloseSession();

      if (error == 0)
      {
        USB.println(F("2.3. FTP close session OK"));
      }
      else
      {
        USB.print(F("2.3. Error calling 'ftpCloseSession' function. error: "));
        USB.println(error, DEC);
        USB.print(F("CMEE error: "));
        USB.println(_4G._errorCode, DEC);
      }
    }
    else
    {
      USB.print(F( "2.1. FTP connection error: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
  }


  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("3. Switch OFF 4G module"));
  _4G.OFF();
}




void OTA_setup_check( int att = 1)
// asta reprogrameaza in practica , variabila att numara de cate ori va incerca re se reprogrameza
// fara succes pana se va renunta
{
  int q = 1;
  bool w = false;
  while ( q <= att && w == false)
  {
    USB.print(F("atempt: "));
    USB.print(q);
    USB.print(F("/"));
    USB.println(att);
    // show program ID
    Utils.getProgramID(programID);
    linie_de_minus(1);
    USB.print(F("Program id: "));
    USB.println(programID);

    // show program version number
    USB.print(F("Program version: "));
    USB.println(Utils.getProgramVersion(), DEC);
    linie_de_minus(1);

    status = Utils.checkNewProgram();

    switch (status)
    {
    case 0:
      USB.println(F("REPROGRAMMING ERROR"));
      Utils.blinkRedLED(300, 3);
      q++;
      break;

    case 1:
      USB.println(F("REPROGRAMMING OK"));
      Utils.blinkGreenLED(300, 3);
      w = true;
      break;

    default:
      USB.println(F("RESTARTING"));
      Utils.blinkGreenLED(500, 1);
      q++;
    }
  }

}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//citire senzori

void cititor_meteo()
{
  uint8_t q = 0;
  // 2. Read the sensor
eve:
  q++;
  response = mySensor6.read();
  if ( (response == 1) && (q <= 5) )
  {
    // 4. Print information
    linie_de_minus(1);
    USB.println(F("GMX"));
    USB.print(F("Wind direction: "));
    USB.print(mySensor6.gmx.windDirection);
    USB.println(F(" degrees"));
    USB.print(F("Avg. wind dir: "));
    USB.print(mySensor6.gmx.avgWindDirection);
    USB.println(F(" degrees"));
    USB.print(F("Cor. wind dir: "));
    USB.print(mySensor6.gmx.correctedWindDirection);
    USB.println(F(" degrees"));
    USB.print(F("Avg. cor. wind dir:"));
    USB.print(mySensor6.gmx.avgCorrectedWindDirection);
    USB.println(F(" degrees"));
    USB.print(F("Avg. wind gust dir: "));
    USB.print(mySensor6.gmx.avgWindGustDirection);
    USB.println(F(" degrees"));
    USB.print(F("Wind speed: "));
    USB.printFloat(mySensor6.gmx.windSpeed, 2);
    USB.println(F(" m/s"));
    USB.print(F("Avg. wind speed: "));
    USB.printFloat(mySensor6.gmx.avgWindSpeed, 2);
    USB.println(F(" m/s"));
    USB.print(F("Avg. wind gust speed:"));
    USB.printFloat(mySensor6.gmx.avgWindGustSpeed, 2);
    USB.println(F(" m/s"));
    USB.print(F("Wind sensor status: "));
    USB.println(mySensor6.gmx.windSensorStatus);
    USB.print(F("Precip. total: "));
    USB.printFloat(mySensor6.gmx.precipTotal, 3);
    USB.println(F(" mm"));
    USB.print(F("Precip. int: "));
    USB.printFloat(mySensor6.gmx.precipIntensity, 3);
    USB.println(F(" mm"));
    USB.print(F("Precip. status: "));
    USB.println(mySensor6.gmx.precipStatus, DEC);
    linie_de_minus(1);
    USB.print(F("Solar radiation: "));
    USB.print(mySensor6.gmx.solarRadiation);
    USB.println(F(" W/m^2"));
    USB.print(F("Sunshine hours: "));
    USB.printFloat(mySensor6.gmx.sunshineHours, 2);
    USB.println(F(" hours"));
    USB.print(F("Sunrise: "));
    USB.print(mySensor6.gmx.sunriseTime);
    USB.println(F(" (h:min)"));
    USB.print(F("Solar noon: "));
    USB.print(mySensor6.gmx.solarNoonTime);
    USB.println(F(" (h:min)"));
    USB.print(F("Sunset: "));
    USB.print(mySensor6.gmx.sunsetTime);
    USB.println(F(" (h:min)"));
    USB.print(F("Sun position: "));
    USB.print(mySensor6.gmx.sunPosition);
    USB.println(F(" (degrees:degrees)"));
    USB.print(F("Twilight civil: "));
    USB.print(mySensor6.gmx.twilightCivil);
    USB.println(F(" (h:min)"));
    USB.print(F("Twilight nautical: "));
    USB.print(mySensor6.gmx.twilightNautical);
    USB.println(F(" (h:min)"));
    USB.print(F("Twilight astronomical: "));
    USB.print(mySensor6.gmx.twilightAstronom);
    USB.println(F(" (h:min)"));
    linie_de_minus(1);
    USB.print(F("Barometric pressure: "));
    USB.printFloat(mySensor6.gmx.pressure, 1);
    USB.println(F(" hPa"));
    USB.print(F("Pressure at sea level: "));
    USB.printFloat(mySensor6.gmx.pressureSeaLevel, 1);
    USB.println(F(" hPa"));
    USB.print(F("Pressure at station: "));
    USB.printFloat(mySensor6.gmx.pressureStation, 1);
    USB.println(F(" hPa"));
    USB.print(F("Relative humidity: "));
    USB.print(mySensor6.gmx.relativeHumidity);
    USB.println(F(" %"));
    USB.print(F("Air temperature: "));
    USB.printFloat(mySensor6.gmx.temperature, 1);
    USB.println(F(" Celsius degrees"));
    USB.print(F("Dew point: "));
    USB.printFloat(mySensor6.gmx.dewpoint, 1);
    USB.println(F(" degrees"));
    USB.print(F("Absolute humidity: "));
    USB.printFloat(mySensor6.gmx.absoluteHumidity, 2);
    USB.println(F(" g/m^3"));
    USB.print(F("Air density: "));
    USB.printFloat(mySensor6.gmx.airDensity, 1);
    USB.println(F(" Kg/m^3"));
    USB.print(F("Wet bulb temperature: "));
    USB.printFloat(mySensor6.gmx.wetBulbTemperature, 1);
    USB.println(F(" Celsius degrees"));
    USB.print(F("Wind chill: "));
    USB.printFloat(mySensor6.gmx.windChill, 1);
    USB.println(F(" Celsius degrees"));

    USB.print(F("Heat index: "));
    USB.print(mySensor6.gmx.heatIndex);
    USB.println(F(" Celsius degrees"));
    linie_de_minus(1);
    USB.print(F("Compass: "));
    USB.print(mySensor6.gmx.compass);
    USB.println(F(" degrees"));
    USB.print(F("X tilt: "));
    USB.printFloat(mySensor6.gmx.xTilt, 0);
    USB.println(F(" degrees"));
    USB.print(F("Y tilt: "));
    USB.printFloat(mySensor6.gmx.yTilt, 0);
    USB.println(F(" degrees"));
    USB.print(F("Z orient: "));
    USB.printFloat(mySensor6.gmx.zOrient, 0);
    USB.println();
    USB.print(F("Timestamp: "));
    USB.println(mySensor6.gmx.timestamp);
    USB.print(F("Voltage: "));
    USB.printFloat(mySensor6.gmx.supplyVoltage, 1);
    USB.println(F(" V"));
    USB.print(F("Status: "));
    USB.println(mySensor6.gmx.status);

    linie_de_minus(1);
  }
  else
  {
    USB.println(F("Sensor not connected or invalid data"));
    USB.print(F("This was atempt: "));
    USB.print(q);
    USB.println(F("/5"));
    USB.println(F("We will reatempt to do a reading in 10s"));
    delay(10000);
    goto eve;
  }

  if ( q >= 6)
  {
    USB.println(F("All atempts failed, aborting process for this loop and continueing main programm"));
  }
}






int frunzarie()
{
  int wett = -5;
  leafWetness mySensor3;

  // 2. Turn ON the sensor
  mySensor3.ON();

  // 3. Read the sensor. Values stored in class variables
  // Check complete code example for details
  mySensor3.read();

  // 4. Turn off the sensor
  mySensor3.OFF();

  // 4. Print information
  linie_de_minus(1);
  USB.println(F("Pythos31"));
  USB.print(F("Leaf wetness:"));
  wett = mySensor3.wetness;
  USB.printFloat(wett , 4);
  USB.println(F(" V"));
  linie_de_minus(1);
  return wett;
}






void masurator_agroo()
{
  uint8_t joyy;
  int umezeala_frunza;


  // 2. Turn ON the sensor
  mySensor1.ON();

  // 3. Read the sensor. Values stored in class variables
  // Check complete code example for details
  mySensor1.read();

  // 4. Turn off the sensor
  mySensor1.OFF();
  // 4. Conversion of dielectric permittivity into Volumetric Water Content (VWC)
  // for mineral soil using Topp equation
  float VWC = ((4.3 * pow(10, -6) * pow(mySensor1.sensor5TE.dielectricPermittivity, 3))
               - (5.5 * pow(10, -4) * pow(mySensor1.sensor5TE.dielectricPermittivity, 2))
               + (2.92 * pow(10, -2) * mySensor1.sensor5TE.dielectricPermittivity)
               - (5.3 * pow(10, -2))) * 100 ;

  // 5. Print information
  linie_de_minus(1);
  USB.println(F("5TE"));
  USB.print(F("Dielectric Permittivity: "));
  USB.printFloat(mySensor1.sensor5TE.dielectricPermittivity, 2);
  USB.println();
  USB.print(F("Volumetric Water Content: "));
  USB.printFloat(VWC, 2);
  USB.println(F(" %VWC"));
  USB.print(F("Electrical Conductivity: "));
  USB.printFloat(mySensor1.sensor5TE.electricalConductivity, 2);
  USB.println(F(" dS/m"));
  USB.print(F("Soil temperature: "));
  USB.printFloat(mySensor1.sensor5TE.temperature, 1);
  USB.println(F(" degrees Celsius"));
  linie_de_minus(1);



  // 2. Turn ON the sensor
  mySensor2.ON();

  // 3. Read the sensor. Values stored in class variables
  // Check complete code example for details
  mySensor2.read();

  // 4. Turn off the sensor
  mySensor2.OFF();

  // 4. Print information
  linie_de_minus(1);
  USB.println(F("ATMOS 14"));
  USB.print(F("Vapor Pressure:"));
  USB.printFloat(mySensor2.sensorVP4.vaporPressure, 3);
  USB.println(F(" kPa"));
  USB.print(F("Temperature:"));
  USB.printFloat(mySensor2.sensorVP4.temperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.print(F("Relative Humidity:"));
  USB.printFloat(mySensor2.sensorVP4.relativeHumidity, 1);
  USB.println(F(" %RH"));
  USB.print(F("Atmospheric Pressure:"));
  USB.printFloat(mySensor2.sensorVP4.atmosphericPressure, 2);
  USB.println(F(" kPa"));
  linie_de_minus(1);






  // 2. Turn ON the sensor
  mySensor4.ON();

  // 3. Initialization delay, necessary for this sensor
  delay(60000);

  // 4. Read the sensor. Values stored in class variables
  // Check complete code example for details
  mySensor4.read();

  // 5. Turn off the sensor
  mySensor4.OFF();

  // 4. Print information
  linie_de_minus(1);
  USB.println(F("SO-411"));
  USB.print(F("Calibrated Oxigen: "));
  USB.printFloat(mySensor4.sensorSO411.calibratedOxygen, 3);
  USB.println(F(" %"));
  USB.print(F("Body temperature: "));
  USB.printFloat(mySensor4.sensorSO411.bodyTemperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.print(F("Sensor millivolts: "));
  USB.printFloat(mySensor4.sensorSO411.milliVolts, 4);
  USB.println(F(" mV"));
  linie_de_minus(1);



  // 1. Turn ON the sensor
  mySensor5.ON();
  // 2. Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
    Values are available as a float value
  */
  mySensor5.read();
  // 3. Turn off the sensor
  mySensor5.OFF();
  // 4. Print information
  linie_de_minus(1);
  USB.println(F("SQ-110"));
  USB.print(F("PA Radiation: "));
  USB.printFloat(mySensor5.radiation, 2);
  USB.println(F(" umol*m-2*s-1"));
  USB.print(F("Sensor voltage: "));
  USB.printFloat(mySensor5.radiationVoltage, 4);
  USB.println(F(" V"));
  linie_de_minus(1);


  cititor_meteo();
  umezeala_frunza = frunzarie();













  frame.createFrame(ASCII, node_ID);
  // It is mandatory to specify the Smart Agriculture Xtreme type
  frame.setFrameType(INFORMATION_FRAME_AGR_XTR);

  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());
  frame.addSensor(SENSOR_TIME, RTC.getTimestamp());



  // add Socket A sensor values
  frame.addSensor(AGRX_5TE_DP2_A, mySensor1.sensor5TE.dielectricPermittivity);
  frame.addSensor(AGRX_5TE_EC2_A, mySensor1.sensor5TE.electricalConductivity);
  frame.addSensor(AGRX_5TE_TC4_A, mySensor1.sensor5TE.temperature);
 // frame.addSensor(AGRX_5TE_VWC_A, VWC);

  // add Socket B sensor values
  frame.addSensor(AGRX_LW, umezeala_frunza);

  // add Socket C sensor values
  frame.addSensor(AGRX_VP4_TC5_C, mySensor2.sensorVP4.temperature);
  frame.addSensor(AGRX_VP4_RH_C, mySensor2.sensorVP4.relativeHumidity);
  frame.addSensor(AGRX_VP4_AP_C, mySensor2.sensorVP4.atmosphericPressure);
  frame.addSensor(AGRX_VP4_VP_C, mySensor2.sensorVP4.vaporPressure);

  // add Socket D sensor values
  frame.addSensor(AGRX_SO411_TC2_D, mySensor4.sensorSO411.bodyTemperature);
  frame.addSensor(AGRX_SO411_CO_D, mySensor4.sensorSO411.calibratedOxygen);
  frame.addSensor(AGRX_SO411_MV2_D, mySensor4.sensorSO411.milliVolts);


  // add Socket E sensor values
  frame.addSensor(AGRX_GMX_AWD, mySensor6.gmx.avgWindDirection);
  frame.addSensor(AGRX_GMX_AWS, mySensor6.gmx.avgWindSpeed);
  frame.addSensor(AGRX_GMX_PI, mySensor6.gmx.precipIntensity);
  frame.addSensor(AGRX_GMX_PT, mySensor6.gmx.precipTotal);    // se mai pot adauga multi aici 


  // add Socket F sensor values
  frame.addSensor(AGRX_SR_F, mySensor5.radiation);



  frame.showFrame();





  if ( PWR.getBatteryLevel() < 20)
  {
    USB.print(F("LOW BATTERY ABANDONING TRANSMISION ATEMPT IN ORDER TO KEEP THE STATION ALIVE AND RECORDING DATA ON THE SD"));
    ssent = 0;
    goto RIUK;
  }


  joyy = 0;
gooo:
  ssent = HTTP_4G_TRIMITATOR_FRAME();
  if ( ssent != 1 && joyy <= resend_f)
  {
    joyy++;
    delay(1000);
    goto gooo;
  }
RIUK:




  scriitor_SD(filename, ssent);




}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// main loops


void setup()
{
  // put your setup code here, to run once:

}


void loop()
{
  // put your main code here, to run repeatedly:












}



