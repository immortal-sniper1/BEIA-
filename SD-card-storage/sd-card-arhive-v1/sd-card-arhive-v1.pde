#include <WaspFrame.h>


// define variable
uint8_t error;

// messure every 10 minutes
unsigned long delay_interval = 900000;

// define file name: MUST be 8.3 SHORT FILE NAME
char filename[]="FILE1.TXT";

// define an example string
int data;
char data2[4];

// define variable
uint8_t sd_answer;








void setup()
{
  // open USB port
  USB.ON();



  USB.println(F("SD_3 example"));
  
  // Set SD ON
  SD.ON();
    
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
    
  // Create file
  sd_answer = SD.create(filename);
  
  if( sd_answer == 1 )
  {
    USB.println(F("file created"));
  }
  else 
  {
    USB.println(F("file NOT created"));  
  } 




//pm
USB.ON();
}


void loop()
{
  SD.ON();

  
  sd_answer = SD.append(filename, "battery: ");
    if( sd_answer =! 1 )
  {
    USB.println(F("\n2 - append error"));
  }

  
  data=PWR.getBatteryLevel();
  itoa(data , data2 , 10);
  /*
  USB.print("data: "); 
  USB.println(data); 
  USB.print("data2: "); 
  USB.println(data2); 
  */
  
  sd_answer = SD.appendln(filename,  data2 );
  if( sd_answer =! 1 )
  {
    USB.println(F("\n2 - append error"));
  }

  
      USB.print("battery: "); 
      USB.println(PWR.getBatteryLevel(), DEC);


  ///////////////////////////////////////////
  // 1. Turn on sensors and wait
  ///////////////////////////////////////////
 // Power on the OPC_N2 sensor. 
    // If the gases PRO board is off, turn it on automatically.
  
  // create new frame
  frame.createFrame(BINARY, NODE_ID);  
  

  // add frame fields
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel()); 
 
    // Show the frame
  frame.showFrame();

  ///////////////////////////////////////////
  // 2. Send packet
  ///////////////////////////////////////////  

  

    USB.print("time: ");
    USB.print(   millis() /1000 );
    USB.println(" s");
    sd_answer = SD.append(filename, "time: ");
    itoa(millis() /1000 , data2 , 10);
    sd_answer = SD.append(filename, data2);
    sd_answer = SD.appendln(filename, " s");
    sd_answer = SD.appendln(filename, "-----------------------------------");    
    SD.OFF();

  USB.println(F("-------------------------------"));
  USB.print(F("Going to sleep for "));
  USB.print(delay_interval / 50000);
  USB.println(F(" secounds."));
  USB.println(F("-------------------------------"));
  USB.println(" ");
  USB.println(" ");
  USB.println(" ");
  USB.println(" ");
  USB.println(" ");
        

  // sleep
  delay(delay_interval/50);
}
