// Library include
#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>
#include <WaspWIFI_PRO.h>
#include <WaspPM.h>



///// EDITEAZA AICI DOAR
char node_ID[] = "TestMedie";
int count_trials = 0;
int N_trials = 5;
char ESSID[] = "LANCOMBEIA";
char PASSW[] = "beialancom";
uint8_t max_atemptss = 10; // nr de max de trame de retrimit deodata
uint8_t resend_f = 2; // frame resend atempts
int cycle_time2 = 120; // in seconds
uint8_t error;
unsigned long prev, previous;
int x, b, cycle_time;
uint8_t status = false;

int partt1, partt2, partt3;





// choose NTP server settings
///////////////////////////////////////
char SERVER1[] = "time.nist.gov";
char SERVER2[] = "wwv.nist.gov";
//"pool.ntp.org";
///////////////////////////////////////

// Define Time Zone from -12 to 12 (i.e. GMT+2)
///////////////////////////////////////
uint8_t time_zone = 3;
///////////////////////////////////////

// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////
// choose URL settings
///////////////////////////////////////
char type[] = "http";
char host[] = "82.78.81.178";
char port[] = "80";


// O2 Sensor must be connected in SOCKET_1
O2SensorClass O2Sensor(SOCKET_1);

// Percentage values of Oxygen
#define POINT1_PERCENTAGE 0.0
#define POINT2_PERCENTAGE 5.0

// Calibration Voltage Obtained during calibration process (in mV)
#define POINT1_VOLTAGE 0.35
#define POINT2_VOLTAGE 2.0

float concentrations_o2[] = {POINT1_PERCENTAGE, POINT2_PERCENTAGE};
float voltages[] =          {POINT1_VOLTAGE,    POINT2_VOLTAGE};





// LPG Sensor can be connected in SOCKET6 or SOCKET7
LPGSensorClass LPGSensor(SOCKET_7);

// Concentratios used in calibration process (PPM VALUE)
#define POINT1_PPM_LPG 10.0   //  <-- Normal concentration in air
#define POINT2_PPM_LPG 50.0
#define POINT3_PPM_LPG 100.0

// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_LPG 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_LPG 25.50
#define POINT3_RES_LPG 3.55

// Define the number of calibration points
#define numPoints 3


float concentrations_lps[] = {POINT1_PPM_LPG, POINT2_PPM_LPG, POINT3_PPM_LPG};
float voltages_lps[] =       {POINT1_RES_LPG, POINT2_RES_LPG, POINT3_RES_LPG};

//char node_ID[] = "LPG_example";

CO2SensorClass CO2Sensor(SOCKET_2);

// Concentratios used in calibration process
#define POINT1_PPM_CO2 350.0    // PPM VALUE <-- Normal concentration in air
#define POINT2_PPM_CO2 1000.0   // PPM VALUE
#define POINT3_PPM_CO2 3000.0   // PPM VALUE

// Calibration vVoltages obtained during calibration process
#define POINT1_VOLT_CO2 0.300
#define POINT2_VOLT_CO2 0.350
#define POINT3_VOLT_CO2 0.380

float concentrations_co2[] = {POINT1_PPM_CO2, POINT2_PPM_CO2, POINT3_PPM_CO2};
float voltages_co2[] =       {POINT1_VOLT_CO2, POINT2_VOLT_CO2, POINT3_VOLT_CO2};


float temperature = 0.0;























void WiFi_init()
{
  // 1. Switch ON the WiFi module
  //////////////////////////////////////////////////
  error = 1;
  while (error == 1)
  {
    error = WIFI_PRO.ON(socket);


    if (error == 0)
    {
      USB.println(F("1. WiFi switched ON"));
    } else
    {
      USB.println(F("1. WiFi did not initialize correctly"));
    }
  }

  // 2. Reset to default values
  //////////////////////////////////////////////////
  error = 1;
  while (error == 1)
  {
    error = WIFI_PRO.resetValues();

    if (error == 0)
    {
      USB.println(F("2. WiFi reset to default"));
    } else {
      USB.println(F("2. WiFi reset to default ERROR"));
    }
  }
  // 3. Set ESSID
  //////////////////////////////////////////////////
  error = 1;
  while (error == 1)
  {
    error = WIFI_PRO.setESSID(ESSID);

    if (error == 0)
    {
      USB.println(F("3. WiFi set ESSID OK"));
    } else {
      USB.println(F("3. WiFi set ESSID ERROR"));
    }
  }
  //////////////////////////////////////////////////
  // 4. Set password key (It takes a while to generate the key)
  // Authentication modes:
  //    OPEN: no security
  //    WEP64: WEP 64
  //    WEP128: WEP 128
  //    WPA: WPA-PSK with TKIP encryption
  //    WPA2: WPA2-PSK with TKIP or AES encryption
  //////////////////////////////////////////////////
  error = 1;
  while (error == 1)
  {
    error = WIFI_PRO.setPassword(WPA2, PASSW);

    if (error == 0)
    {
      USB.println(F("4. WiFi set AUTHKEY OK"));
    } else
    {
      USB.println(F("4. WiFi set AUTHKEY ERROR"));
    }
  }
  //////////////////////////////////////////////////
  // 5. Software Reset
  // Parameters take effect following either a
  // hardware or software reset
  //////////////////////////////////////////////////
  error = WIFI_PRO.softReset();

  if (error == 0)
  {
    USB.println(F("5. WiFi softReset OK"));
  } else {
    USB.println(F("5. WiFi softReset ERROR"));
  }

  USB.println(F("*******************************************"));
  USB.println(F("Once the module is configured with ESSID"));
  USB.println(F("and PASSWORD, the module will attempt to "));
  USB.println(F("join the specified Access Point on power up"));
  USB.println(F("*******************************************\n"));
}











//NU MODIFICA NIMIC IN SUBPROGRAME!
int trimitator_WIFI()
{
  int ssent;
  // get actual time before wifi
  previous = millis();
  //////////////////////////////////////////////////
  // 4. Switch ON
  error = WIFI_PRO.ON(socket);
  b = 0;
qwerty:
  if (error == 0)
  {
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
  }
  status = WIFI_PRO.isConnected();
  // check if module is connected
  if (status == true)
  {
    USB.print(F("WiFi is connected OK"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
    USB.print(F(" (time it took for the WIFI status check)"));

    // 3.2. Send Frame
    ///////////////////////////////
    // http frame
    previous = millis();
    error = WIFI_PRO.sendFrameToMeshlium(type, host, port, frame.buffer, frame.length); // frame
    // check response
    if (error == 0)
    {
      USB.println(F("HTTP OK"));
      ssent = 1;
      USB.print(F("HTTP Time from OFF state (ms):"));
      USB.println(millis() - previous);
      USB.println(F("ASCII FRAME SEND OK"));
    } else
    {
      USB.println(F("Error calling 'getURL' function"));
      ssent = 0;
      WIFI_PRO.printErrorCode();
    }
  } else
  {
    USB.print(F("WiFi is connected ERROR"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
  }
  if (ssent == 0 && b <= resend_f)
  {
    delay(5000);
    b++;
    goto qwerty;
  }

  WIFI_PRO.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n"));
  b = (millis() - prev) / 1000;
  USB.print("loop execution time[s]: ");
  USB.println(b);
  return ssent;
}



void fancy_particles( uint8_t x = 16)
{
  // x number of values to average out
  uint8_t ii, OPC_status;
  float sum1 = 0, sum2 = 0, sum3 = 0;
  //Turn on the particle matter sensor
  OPC_status = PM.ON();
  if (OPC_status == 1)
  {
    USB.println(F("Particle sensor started"));
  }
  else
  {
    USB.println(F("Error starting the particle sensor"));
  }

  for (ii = 0; ii < x; ii++)
  {
    // Get measurement from the particle matter sensor
    // Power the fan and the laser and perform a measure of 5 seconds
    //OPC_measure = PM.getPM(5000, 5000);
    PM.getPM(5000, 5000);
    sum1 = sum1 + PM._PM1;
    sum2 = sum2 + PM._PM2_5;
    sum3 = sum3 + PM._PM10;
  }
  partt1 = sum1 / x;
  partt2 = sum2 / x;
  partt3 = sum3 / x;
  USB.println(F("Averageing algorithm ended"));


  PM.OFF();

}



















void setup()
{
  // Open the USB connection
  USB.ON();
  USB.println(F("USB port started..."));
  RTC.ON();
  WiFi_init();
  USB.println(F("RTC time:"));
  USB.println(F("------------------------------------"));
  USB.println(RTC.getTime());
  USB.println(F("------------------------------------\n"));




}

void loop()
{
  USB.println(RTC.getTime());
  USB.print("battery (Volts): ");
  USB.println(PWR.getBatteryVolts());
  USB.print("battery percent: ");
  USB.println((int)(PWR.getBatteryLevel()));
  fancy_particles();










  frame.createFrame(ASCII, node_ID); // frame1 de  stocat
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());
  // Add PM1
  frame.addSensor(SENSOR_GASES_PRO_PM1, PM._PM1, 2);
  // Add PM2.5
  frame.addSensor(SENSOR_GASES_PRO_PM2_5, PM._PM2_5, 2);
  // Add PM10
  frame.addSensor(SENSOR_GASES_PRO_PM10, PM._PM10, 2);
  frame.addTimestamp();
  // Add PM1 value
  frame.addSensor(SENSOR_GASES_PRO_CO2, partt1, 2);
  // Add PM2.5 value
  frame.addSensor(SENSOR_GASES_PRO_NO2, partt2, 2);
  // Add PM10 value
  frame.addSensor(SENSOR_GASES_PRO_SO2, partt3, 2);

  frame.showFrame();
  trimitator_WIFI();

  USB.println(F("------------------------------------------------------"));

  delay(600000);
}
