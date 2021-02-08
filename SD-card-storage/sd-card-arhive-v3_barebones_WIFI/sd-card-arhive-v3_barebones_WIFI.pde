#include <WaspFrame.h>
#include <WaspPM.h>
#include <WaspWIFI_PRO.h> 
#include <WaspSD.h>



// define variable SD
// define file name: MUST be 8.3 SHORT FILE NAME
char filename[]="FILE1.TXT";


char* time_date; // stores curent date + time
int x,b;
char y[3];
uint8_t sd_answer,ssent;
bool sentence=false;   // true for deletion on reboot  , false for data appended to end of file 
bool IRL_time= false;  //  true for no external data source
int  cycle_time,cycle_time2=10;  // in seconds
char rtc_str[]="00:00:00:05";  //11 char ps incepe de la 0
unsigned long prev,previous;





// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET1;
///////////////////////////////////////


// choose URL settings
///////////////////////////////////////
char type[] = "http";
char host[] = "82.78.81.178";
char port[] = "80";
///////////////////////////////////////

uint8_t error;
uint8_t status;

char node_ID[] = "cevax";











// subprograme

void scriitor_SD( char filename_a[] ,uint8_t ssent_a=0)
{
  int coruption=0;
  PWR.deepSleep("00:00:00:05", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  //now storeing it locally 
  SD.ON();
  time_date = RTC.getTime(); 
  USB.print(F("time: "));
  USB.println(time_date);  
  

  x=RTC.year;
  itoa(x, y, 10);
  if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
  sd_answer = SD.append(filename_a,  y  );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption=coruption+sd_answer;
  x=RTC.month;
  itoa(x, y, 10);
  if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
  sd_answer = SD.append(filename_a,  y  );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption=coruption+sd_answer;
  x=RTC.date;
  itoa(x, y, 10);
  if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
  sd_answer = SD.append(filename_a,  y  );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption=coruption+sd_answer;
  x=RTC.hour;
  itoa(x, y, 10);
  if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
  sd_answer = SD.append(filename_a,  y  );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption=coruption+sd_answer;
  x=RTC.minute;
  itoa(x, y, 10);
  if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
  sd_answer = SD.append(filename_a,  y  );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a, ".");
  coruption=coruption+sd_answer;
  x=RTC.second;
  itoa(x, y, 10);
  if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
  sd_answer = SD.append(filename_a,  y  );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a,  "  " );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a,  frame.buffer , frame.length );
  coruption=coruption+sd_answer;
  sd_answer = SD.append(filename_a,  "  " );
  coruption=coruption+sd_answer;
  itoa(ssent_a,y,10);
  sd_answer = SD.appendln(filename_a,  y );
  coruption=coruption+sd_answer;
// frame is stored 
  
  SD.OFF();

  if ( coruption== 15)
  {
        USB.println("SD sorage done with no errors");
  }
  else
  {
        USB.print("SD sorage done with:");
        USB.print(15-coruption);
        USB.println(" errors");
  }

}















//initializare

void setup()
{
  // open USB port
  USB.ON();
  USB.println(F("SD_arhive_V3_RTC"));




  RTC.ON(); // Executes the init process
  if( IRL_time)
  {
    // Setting date and time [yy:mm:dd:dow:hh:mm:ss]
    RTC.setTime("21:02:01:02:00:00:00");
  }
  else
  {
    //ceva primire de data aici
  }


  


  // Set SD ON
  SD.ON();

    if ( sentence) 
    {
        // Delete file
        sd_answer = SD.del(filename);
  
       if( sd_answer == 1 )
       {
        USB.println(F("file deleted"));
       }
       else 
       {
        USB.println(F("file NOT deleted")); 
       }

    }
         // Create file IF id doent exist 
         sd_answer = SD.create(filename);
  
         if( sd_answer == 1 )
         {
           USB.println(F("file created"));
         }
         else 
         {
           USB.println(F("file NOT created"));  
           USB.println(SD.getFileSize(filename) );
         } 
  
       USB.print("loop cycle time[s]:= ");
       USB.println(cycle_time2 );
      sd_answer = SD.appendln(filename,  "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" );


    // Set the Waspmote ID
    frame.setID(node_ID);
USB.ON();
}









//main program
void loop()
{
    // get actual time before loop
  prev=millis();
  USB.ON();

    





  // get actual time before wifi
  previous = millis();
  //////////////////////////////////////////////////
  // 4. Switch ON
  //////////////////////////////////////////////////  

  error = WIFI_PRO.ON(socket);

  if (error == 0)
  {    
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
  }
  status =  WIFI_PRO.isConnected();
  // check if module is connected
  if (status == true)
  {    
    USB.print(F("WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);
    USB.print(F(" (time it took for the WIFI status check)"));   

//frame

    frame.createFrame(ASCII);
    frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());     // Add BAT level
    frame.showFrame(); // frame is made
   


 // 3.2. Send Frame 
    ///////////////////////////////
    // http frame
    previous = millis();
    error = WIFI_PRO.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);   // frame 

    // check response
    if (error == 0)
    {
      USB.println(F("HTTP OK")); 
      ssent=1;
      USB.print(F("HTTP Time from OFF state (ms):"));    
      USB.println(millis()-previous); 
      USB.println(F("ASCII FRAME SEND OK")); 
    }
    else
    {
      USB.println(F("Error calling 'getURL' function"));
      ssent=0;
      WIFI_PRO.printErrorCode();
    }
  }
  else
  {
    USB.print(F("WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);  
  }






  //////////////////////////////////////////////////
  // 3. Switch OFF WIFI
  //////////////////////////////////////////////////  

  WIFI_PRO.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
  b=(millis()-prev)/1000;
  USB.print("loop execution time[s]: ");
  USB.println(b);






  
cycle_time=cycle_time2-b-1;
if ( cycle_time <10)
{
  cycle_time=15;
}
  USB.println(cycle_time);

x=cycle_time%60;  // sec
itoa(x, y, 10);
if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
rtc_str[9]=y[0];
rtc_str[10]=y[1];


x=cycle_time/60%60;  // min
itoa(x, y, 10);
if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
rtc_str[6]=y[0];
rtc_str[7]=y[1];


x=cycle_time/3600%3600;  // h
itoa(x, y, 10);
if(x<10)
{
  y[1]=y[0];
  y[0]='0';
}
rtc_str[3]=y[0];
rtc_str[4]=y[1];

///-------------














  frame.createFrame(ASCII, node_ID);  // frame1 de  stocat
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());
  scriitor_SD( filename, ssent);
  









  // Go to deepsleep  

  ////////////////////////////////////////////////
  // 5. Sleep
  ////////////////////////////////////////////////
  USB.println(F("5. Enter deep sleep..."));
  USB.print("X");USB.print(rtc_str);USB.println("X");

  USB.println("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
  USB.OFF();

  PWR.deepSleep(rtc_str, RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.println(F("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
  USB.println(F("6. Wake up!!\n\n"));

}


