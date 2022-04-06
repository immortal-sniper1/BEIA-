#ifndef MorseLIB_h
#define MorseLIB_h     // Basically, this prevents problems if someone accidently #include's your library twice.





#include "Arduino.h"




class MorseCaSiClasa
{
  public:
    MorseCaSiClasa(int pin);
    void dot( uint8_t count );
    void dash( uint8_t count );
    void TextCharCount( char txt[]);

  private:
    int _pin;
};


#endif
