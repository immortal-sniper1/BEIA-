//AES encrypt
// lib
#include "WaspAES.h"


// Define a 16-Byte (AES-128) private key to encrypt message
char password[] = "libeliumlibelium";
// Define Initial Vector
uint8_t IV[16] = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F};
// Variable for encrypted message's length
uint16_t encrypted_length;
// 2. Declaration of variable encrypted message with enough memory space
uint8_t encrypted_message[300];

// void setup


//void loop , DUPA ce un frame este creat

// 2.1. Calculate length in Bytes of the encrypted message
encrypted_length = AES.sizeOfBlocks(frame.length);

// 2.2. Calculate encrypted message with ECB cipher mode and PKCS5 padding.
AES.encrypt(  128
              , password
              , frame.buffer
              , frame.length
              , encrypted_message
              , CBC
              , PKCS5
              , IV);

// 2.3. Printing encrypted message
USB.print(F("AES Encrypted message:"));
USB.println(F("-------------------------"));
AES.printMessage( encrypted_message, encrypted_length);
USB.println(F("-------------------------"));

//NOTE:
//4G
error = _4G.sendFrameToMeshlium( host, port, frame.buffer, frame.length);
//se inlocuieste cu :
error = _4G.sendFrameToMeshlium( host, port, encrypted_message, encrypted_length);



//WIFI
error = WIFI_PRO.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);
//se inlocuieste cu :
error = WIFI_PRO.sendFrameToMeshlium( type, host, port, encrypted_message, encrypted_length);

//EXEMPLU

//Current ASCII Frame:
//Length: 63
//Frame Type:  134
//frame (HEX): 3C3D3E86022334453245314345383139363233433632236E6F64655F3030312330235354523A746869735F69735F615F6D657373616765234241543A373823
//frame (STR): <=>†#4E2E1CE819623C62#node_001#0#STR:this_is_a_message#BAT:78#
//===============================

//2. Encrypting Frame
//AES Encrypted message: "7B9558D56F02CB5E105C35F0596DA867148D5360B5429230A1DC35189F4E80F6CB3C1641C25E1E55545D3548C1EF073DFAC17E116C851E29BF5671F3F9C6C184"
//AES Encrypted length:64























//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//RSA encrypt
// lib
#include "WaspRSA.h"



// 1. Declaration of Public key variables
char public_modulus[] =
  "7ebd3e97454cc46ebcf758a5b0b1ddfc" \
  "4775878048968cf3b2aaa0e34b8b0553" \
  "15005c21a4e31404ebe82485ee114918" \
  "8a5b96605c3f4437ef7deeff30a5eaa4" \
  "af944c4405a1c3ac1f0d54453194f212" \
  "ea50d6c04aee07b1c8c9a37661ad9126" \
  "604f754f7270503f7b61fa7b72367cac" \
  "7c871203caa31d77aa0616571ecf388b" ;

// define exponent for public key 'e'
// This key is defined as HEX format:
// 0x00010001 = 65537 which is a prime number
char public_exponent[] = "00010001";


char private_exponent[] =
  "4ea5689dbe27310df6bd16895ae844f4" \
  "33f3beade05d6c021db0bc3dcfb6e90a" \
  "f15153da9cd33cad012700e30b2436d3" \
  "bfa7addd05e14c97d949b07132e30283" \
  "663f39a32662d951d7d53ef92ef39d2e" \
  "a791689065f656f5ffb5f60c92f91b98" \
  "1f8127a90235a05d9b82c223d43bce92" \
  "002b097e6634be3141f480d4e5333341" ;

char p[] =
  "cada49cc750e4ff40bad216aa2ff3a69" \
  "c5cbcc6d2a320dd81a098e5a995e30dc" \
  "f40a0a775130471f3a4ebd364a003f6a" \
  "65b2a02be98f7394258c51c324f1da03" ;

char q[] =
  "9ff1e238eb0217b573239fd0b98fac6a" \
  "97907f0534e2c59356e637e400e0b8a2" \
  "497d7f53a614a29991dfb630e5d74b7f" \
  "95e10c9663a34f67fc65009f51b724d9" ;

char dp[] =
  "39924a6fa4a93337e83872cb790746e4" \
  "ce2651168a6b3a52a2d1237dc3196074" \
  "d52e245a48c892e6e1fd86e5e98ab874" \
  "d1f8284d4e3450713356e7bda2b6a151" ;

char dq[] =
  "6c08eafffd2525b4873819dbd76b074f" \
  "dc5e5a9dbeb22a38326b40773e6c8be9" \
  "fa6fcd50480f0a2166d9cfeb496459f7" \
  "acda1d317bcdb4760d927f901d96f249" ;

char qp[] =
  "513c04961d1c7c762b49f37d02b12538" \
  "569fc1ad0a158f7ba8c2a1217158b9d9" \
  "c4b9ca80a989466544d497c233c2dd43" \
  "51ffe83b760fe8a6de4737ecef77b0ba" ;


// variable to store the encrypted message
char enc_message[300];



// void setup


//void loop , DUPA ce un frame este creat

// Calculating encrypted message
RSA.encrypt(frame.buffer
            , frame.length
            , public_exponent
            , public_modulus
            , enc_message
            , sizeof(enc_message));

USB.println(F("-------------------------"));
USB.println(F("Encrypted message:"));
USB.println(F("-------------------------"));
RSA.printMessage(enc_message);
USB.println(F("-------------------------"));



//EXEMPLU

//===============================
//Current ASCII Frame:
//Length: 63
//Frame Type:  134
//frame (HEX): 3C3D3E8602233445324531434538313936323343363223574153505F656E63727970746564233230235354523A58426565206672616D65234241543A373823
//frame (STR): <=>†#4E2E1CE819623C62#WASP_encrypted#20#STR:XBee frame#BAT:78#
//===============================

//2. Encrypting Frame
//-------------------------
//Encrypted message:
//-------------------------
//6332860CE012B90F65583E61932C54B4
//A983B68F54138C24260CE5577A1B58FB
//C256544BE813F2ED9866711194B0F401
//D3A14B2A1F165740BC7B9C72C4250A01
//FAA3CF3DF3EC97E2D3ED0F6C0556EC77
//455758C50BFB8366D49E0CB596F4C7F3
//11C232AE6C3C772C888CECFDE4FF6A1B
//6EEADCE3EBE53B919F3BFB120797CA78

//-------------------------


