#include "Arduino.h"
#include "MorseLIB.h"


//There are a couple of strange things in this code. First is the MorseCaSiClasa:: before
//the name of the function. This says that the function is part of the MorseCaSiClasa class

MorseCaSiClasa::MorseCaSiClasa(int pin)
{
  pinMode(pin, OUTPUT);
  _pin = pin;
}


void MorseCaSiClasa::dot(uint8_t count = 1)
{
  for (uint8_t i = 0;  i < count;  i++)
  {
    digitalWrite(_pin, HIGH);
    delay(250);
    digitalWrite(_pin, LOW);
    delay(250);
  }
}

void MorseCaSiClasa::dash(uint8_t count = 1)
{
  for (uint8_t i = 0;  i < count;  i++)
  {
    digitalWrite(_pin, HIGH);
    delay(1000);
    digitalWrite(_pin, LOW);
    delay(250);
  }
}

void TextCharCount( char txt[]);
{
  dot( sizeof.txt[] );
}
