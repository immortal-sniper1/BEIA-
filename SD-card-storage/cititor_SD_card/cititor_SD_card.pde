

// define file name: MUST be 8.3 SHORT FILE NAME
char filename[]="/data/frames.TXT";

// array in order to read data
char output[101];

// define variable
uint8_t sd_answer;


void setup()
{
  // open USB port
  USB.ON();
  USB.println(F("SD_4 example"));
  
  // Set SD ON
  SD.ON();
    

  

  USB.print(F("SHOW THE FILE CONTENTS"));
  SD.showFile(filename);
  
  delay(3000);  
  
}


void loop()
{ 
//
 
}


