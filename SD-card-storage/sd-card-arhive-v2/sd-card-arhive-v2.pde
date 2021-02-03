#include <WaspFrame.h>
#include <WaspSD.h>

// define variable
uint8_t error;


// define file name: MUST be 8.3 SHORT FILE NAME
char filename[]="FILE1.TXT";
char* time_date; // stores curent date + time
// define an example string
int data, first_lost,x;
char y[3];

// define variable
uint8_t sd_answer;
int sentence=0;   // 1 for deletion on reboot  , anything else for data appended to fiel only
bool IRL_time= true;  //  true for no external data source
int cycle_time=15;  // in seconds
char rtc_str[]="00:00:00:05";  //11 char ps incepe de la 0


void setup()
{
  // open USB port
  USB.ON();
  RTC.ON(); // Executes the init process
  first_lost=-7;
  if( IRL_time)
  {
    // Setting date and time [yy:mm:dd:dow:hh:mm:ss]
    RTC.setTime("21:02:01:02:00:00:00");
  }
  else
  {
    //ceva primire de data aici
  }

  USB.println(F("SD_arhive_V2"));
  
  // Set SD ON
  SD.ON();

    if ( sentence==1) 
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
         } 
  

      sd_answer = SD.appendln(filename,  "----------------------------------------------------------------------------" );

//pm
USB.ON();
}


void loop()
{
  USB.ON();
  SD.ON();


  // create new frame
  frame.createFrame(BINARY, "ceva id");  // farame de trimis 
  

  // add frame fields
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel()); 
 // data is sent here
    frame.showFrame();



 //frame for local storage
   frame.createFrame(ASCII, "ceva id");
  // add frame fields
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel()); 

  //frame.showFrame();

  time_date = RTC.getTime(); 
  USB.print(F("time: "));
  USB.println(time_date);  
  
  x=RTC.year;
  itoa(x, y, 10);
  sd_answer = SD.append(filename,  y  );
  sd_answer = SD.append(filename, ".");
  x=RTC.month;
  itoa(x, y, 10);
  sd_answer = SD.append(filename,  y  );
  sd_answer = SD.append(filename, ".");
  x=RTC.day;
  itoa(x, y, 10);
  sd_answer = SD.append(filename,  y  );
  sd_answer = SD.append(filename, ".");
  x=RTC.hour;
  itoa(x, y, 10);
  sd_answer = SD.append(filename,  y  );
  sd_answer = SD.append(filename, ".");
  x=RTC.minute;
  itoa(x, y, 10);
  sd_answer = SD.append(filename,  y  );
  sd_answer = SD.append(filename, ".");
  x=RTC.second;
  itoa(x, y, 10);
  sd_answer = SD.append(filename,  y  );
  sd_answer = SD.append(filename, ".");


  //USB.println("random1");
  sd_answer = SD.append(filename,  "  " );
  //USB.println("random2");
  sd_answer = SD.append(filename,  frame.buffer , frame.length );
  sd_answer = SD.append(filename,  "  " );
  sd_answer = SD.appendln(filename,  "ceva date de scris vin aici " );


  

x=cycle_time/60;
x=cycle_time/3600;




  USB.println(rtc_str);

  USB.println("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
  SD.OFF();
  USB.OFF();

  PWR.deepSleep(rtc_str, RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);


//delay(66600);
  


};

void lost_frames( int x)
{
  if(first_lost<x and first_lost != -7)
  first_lost=first_lost;
  else
  first_lost=x;
};
//     first_lost++;
//     USB.println( SD.cat( filename, 13 , 53 ) );  citeste de le linia  13  53  de caractere

/* 
int data_resender ( char filename , int first_lost )
{
   USB.println( SD.cat( filename, first_lost , frame.length ) );



  return 1;
}

*/



