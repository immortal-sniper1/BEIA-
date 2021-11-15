//#include <cmsis_os.h>
//#include <croutine.h>
//#include <event_groups.h>
//#include <FreeRTOS.h>
//#include <FreeRTOSConfig.h>
//#include <FreeRTOSConfig_Default.h>
//#include <list.h>
//#include <message_buffer.h>
//#include <mpu_prototypes.h>
//#include <portmacro.h>
//#include <queue.h>
//#include <semphr.h>
//#include <stack_macros.h>
//#include <STM32FreeRTOS.h>
//#include <stream_buffer.h>
//#include <task.h>
//#include <timers.h>



#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>

#include <ESP8266HTTPClient.h>
#include <ESP8266httpUpdate.h>


/* Set these to your desired credentials. */
const char *ssid = "LANCOMBEIA"; //Enter your WIFI ssid
const char *password = "beialancom"; //Enter your WIFI password






int pinn = D4;


void setup()
{

pinMode(LED_BUILTIN, OUTPUT);     // Initialize the LED_BUILTIN pin as an output
pinMode(pinn , OUTPUT);     // Initialize the LED_BUILTIN pin as an output


  Serial.begin(115200);
  Serial.println();

  WiFi.begin(ssid , password );

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println();

  Serial.print("Connected, IP address: ");
  Serial.println(WiFi.localIP());
}

// the loop function runs over and over again forever
void loop()
{


  digitalWrite(pinn, LOW);   // Turn the LED on (Note that LOW is the voltage level
  // but actually the LED is on; this is because
  // it is active low on the ESP-01)
  delay(1000);                      // Wait for a second
  digitalWrite(pinn, HIGH);  // Turn the LED off by making the voltage HIGH
  delay(2000);




}
