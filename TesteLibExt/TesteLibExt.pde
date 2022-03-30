#include <test.h>


// Put your libraries here (#include ...)
//#include "test.h"


namespace testtt
{
int a=4;
void setup()
{
  // put your setup code here, to run once:
  USB.ON();



  //a = Add( 13 , 14);
  USB.println(a);
  USB.println(tt);
}


void loop()
{
  // put your main code here, to run repeatedly:

}
}



