
// Put your libraries here (#include ...)
#include <WaspSensorGas_Pro.h>
#include <WaspFrame.h>
//#include <WaspWIFI_PRO.h>

char node_ID[] = "upb_test";
// define file name: MUST be 8.3 SHORT FILE NAME
char filename[] = "FILE1.TXT";
uint8_t sd_answer, ssent;


Gas CO(SOCKET_B);
Gas CO2(SOCKET_A);

bmeGasesSensor  bme;


float concCO2;
float concCO;


float temperature;
float humidity;
float pressure;

void BME280_thing()
{

  // Reads the BME280 sensor
  temperature = bme.getTemperature();
  humidity = bme.getHumidity();
  pressure = bme.getPressure();
}




void scriitor_SD(char filename_a2[], uint8_t ssent_a = 0)
{
  SD.ON();
//  USB.ON();
  USB.print(F("scriitor SD  "));

  long int m;
  //m = 104857600 ; //100MB file size
  m = 1048576;   //10MB file size
  bool q = true;
  int i;
  char filename_a[13];





  for (i = 0; i < 12; i++)
  {
    filename_a[i] = filename_a2[i];
  }
  //USB.println(F("scriitor SD2"));


  i = 1;



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
  USB.println("SD storage done with no errors");
} else {
  USB.print("SD sorage done with:");
  USB.print(15 - coruption);
  USB.println(" errors");
}
}






void setup()
{
  // put your setup code here, to run once:
  // Open the USB connection
  USB.ON();
  USB.println(F("USB port started..."));
  RTC.ON();


  bme.ON();
  CO.ON();
  CO2.ON();

}






void loop()
{
  // put your main code here, to run repeatedly:
    USB.ON();
  USB.println(F("------------------------------------------------------"));

  // And print the values via USB

  BME280_thing();
  concCO2 = CO2.getConc();
  concCO = CO.getConc();



  //USB.println(F("***************************************"));
  USB.print(F("Gas concentration CO: "));
  USB.print(concCO);
  USB.print(F("Gas concentration CO2: "));
  USB.print(concCO2);
  USB.println(F(" ppm"));
  USB.print(F("Temperature: "));
  USB.print(temperature);
  USB.println(F(" Celsius degrees"));
  USB.print(F("RH: "));
  USB.print(humidity);
  USB.println(F(" %"));
  USB.print(F("Pressure: "));
  USB.print(pressure);
  USB.println(F(" Pa"));


  // Add temperature
  frame.addSensor(SENSOR_GASES_PRO_TC, temperature);
  // Add humidity
  frame.addSensor(SENSOR_GASES_PRO_HUM, humidity);
  // Add pressure value
  frame.addSensor(SENSOR_GASES_PRO_PRES, pressure);
  // Add CO2 value
  frame.addSensor(SENSOR_GASES_PRO_CO2, concCO2);
  // Add CO value
  frame.addSensor(SENSOR_GASES_PRO_CO, concCO);

  // Show the frame
  frame.showFrame();

  scriitor_SD(filename, ssent);


  delay(1000);
}
