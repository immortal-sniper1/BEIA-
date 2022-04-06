#include "MorseLIB.h"


//When this line gets executed (which actually happens even before the setup()
// function), the constructor for the Morse class will be called, and passed
// the argument you've given here (in this case, just 13).
MorseCaSiClasa instanta1(3);  // se creaza o instanta a clasei MorseCaSiClasa cu numele instanta1


char t[]="home";
void setup()
{
}

void loop()
{

  instanta1.dot(3);
  instanta1.dash(3);
  instanta1.dot(3);
  delay(3000);
  TextCharCount( t );
}
