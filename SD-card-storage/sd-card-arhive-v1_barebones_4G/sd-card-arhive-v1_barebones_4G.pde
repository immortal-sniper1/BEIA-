#include <WaspFrame.h>
//#include <WaspPM.h>
//#include <WaspSD.h>
#include <Wasp4G.h>

// define variable SD
// define file name: MUST be 8.3 SHORT FILE NAME
char filename[] = "FILE1.TXT";

char *time_date; // stores curent date + time
int x, b;
uint8_t error;
uint8_t status = false;
char y[3];
uint8_t sd_answer, ssent = 0, resend_f = 2; // frame resend atempts
bool sentence = false; // true for deletion on reboot  , false for data appended
// to end of file
bool IRL_time = false; //  true for no external data source
int cycle_time, cycle_time2 = 10; // in seconds
char rtc_str[] = "00:00:00:05";    // 11 char ps incepe de la 0
unsigned long prev, previous;

char node_ID[] = "cevax";


// APN settings
///////////////////////////////////////    pt orange RO
char apn[] = "net";
char login[] = "";
char password[] = "";
///////////////////////////////////////



// SERVER settings
///////////////////////////////////////
char host[] = "test.libelium.com";
uint16_t port = 80;
char resource[] = "/test-get-post.php?varA=1&varB=2&varC=3&varD=4&varE=5&varF=6&varG=7&varH=8&varI=9&varJ=10&varK=11&varL=12&varM=13&varN=14&varO=15";
///////////////////////////////////////

uint8_t connection_status, net_in_attempt;
char operator_name[20];

// subprograme





void scriitor_SD(char filename_a[], uint8_t ssent_a = 0) {
  int coruption = 0;
  PWR.deepSleep("00:00:00:05", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  // now storeing it locally
  SD.ON();
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
  if (x < 10) {
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
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }
  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption = coruption + sd_answer;
  x = RTC.second;
  itoa(x, y, 10);
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }
  sd_answer = SD.append(filename_a, y);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, "  ");
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, frame.buffer, frame.length);
  coruption = coruption + sd_answer;
  sd_answer = SD.append(filename_a, "  ");
  coruption = coruption + sd_answer;
  itoa(ssent_a, y, 10);
  sd_answer = SD.appendln(filename_a, y);
  coruption = coruption + sd_answer;
  // frame is stored

  SD.OFF();

  if (coruption == 15) {
    USB.println("SD sorage done with no errors");
  } else {
    USB.print("SD sorage done with:");
    USB.print(15 - coruption);
    USB.println(" errors");
  }
}




void INFO_4G_MDD()
{
  int temperature;
  USB.ON();
  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
  USB.println("Start INFO_4G_MDD");
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
  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
  USB.OFF();

}





void INFO_4G_NET()
{
  USB.ON();
  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
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
  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
  USB.OFF();

}

void HTTP_GET_4G()
{
  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
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
      USB.print("Server response: ");
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
  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
}








// initializare

void setup() {
  USB.ON();
  RTC.ON();

  INFO_4G_MDD();
  INFO_4G_NET();



  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();






  USB.println(RTC.getTime());
  USB.println(F("SD_CARD_ARHIVE_V1_RTC_ON_4G_BAREBONES"));

  // Set SD ON
  SD.ON();

  if (sentence == 1) {
    // Delete file
    sd_answer = SD.del(filename);

    if (sd_answer == 1) {
      USB.println(F("file deleted"));
    } else {
      USB.println(F("file NOT deleted"));
    }
  }
  // Create file IF id doent exist
  sd_answer = SD.create(filename);

  if (sd_answer == 1) {
    USB.println(F("file created"));
  } else {
    USB.println(F("file NOT created"));
  }

  USB.print("loop cycle time[s]:= ");
  USB.println(cycle_time2);
  sd_answer = SD.appendln(filename, "-------------------------------------------------------------------------------");
  if (sd_answer == 1) {
    USB.println(F("writeing is OK"));
  } else {
    USB.println(F("writeing is haveing errors"));
  }



  // pm
  USB.ON();
  RTC.ON();

}




// main program
void loop() {


  // get actual time before loop
  prev = millis();


  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  frame.createFrame(ASCII, node_ID); // frame1 de  stocat
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());
  frame.showFrame();
  scriitor_SD(filename, ssent);
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  HTTP_GET_4G();







  cycle_time = cycle_time2 - b - 5;
  if (cycle_time < 10) {
    cycle_time = 15;
  }
  USB.print("cycle time= ");
  USB.println(cycle_time);

  x = cycle_time % 60; // sec
  itoa(x, y, 10);
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }
  rtc_str[9] = y[0];
  rtc_str[10] = y[1];

  x = cycle_time / 60 % 60; // min
  itoa(x, y, 10);
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }
  rtc_str[6] = y[0];
  rtc_str[7] = y[1];

  x = cycle_time / 3600 % 3600; // h
  itoa(x, y, 10);
  if (x < 10) {
    y[1] = y[0];
    y[0] = '0';
  }
  rtc_str[3] = y[0];
  rtc_str[4] = y[1];

  ///-------------

  // Go to deepsleep

  ////////////////////////////////////////////////
  // 5. Sleep
  ////////////////////////////////////////////////
  USB.println(F("5. Enter deep sleep..."));
  USB.print("X");
  USB.print(rtc_str);
  USB.println("X");

  //USB.println("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
  USB.OFF();
  delay(30000);
  //PWR.deepSleep(rtc_str, RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.ON();
  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
  USB.println(F("6. Wake up!!\n\n"));




}





