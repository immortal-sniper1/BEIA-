#include <Adafruit_MQTT.h>
#include <Adafruit_MQTT_Client.h>
#include <Adafruit_MQTT_FONA.h>














#include <ESP8266WiFi.h>
//#include <ESP8266WiFiMulti.h>

//#include <ESP8266HTTPClient.h>
//#include <ESP8266httpUpdate.h>


/* Set these to your desired credentials. */
const char *ssid = "LANCOMBEIA"; //Enter your WIFI ssid
const char *password = "beialancom"; //Enter your WIFI password

char server = 'mqtt.beia-telemetrie.ro';
int port = 1883;
//const char  user = "";
//const char pass = "";




int pinn2 = D0;
int pinn = D7;


void setup()
{

  pinMode(LED_BUILTIN, OUTPUT);     // Initialize the LED_BUILTIN pin as an output
  pinMode(pinn , OUTPUT);     // Initialize the LED_BUILTIN pin as an output
  pinMode(pinn2 , OUTPUT);

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
  digitalWrite(pinn2, HIGH);

  Serial.print("Connecting MQTT: ");
  //Adafruit_MQTT.Adafruit_MQTT( server,  port, user, pass );
  Adafruit_MQTT.Adafruit_MQTT( server,  port );
  
  int cc = Adafruit_MQTT.connect();
  Serial.print("Succes= ", cc);




}











// the loop function runs over and over again forever
void loop()
{


  digitalWrite(pinn, LOW);   // Turn the LED on (Note that LOW is the voltage level
  // but actually the LED is on; this is because
  // it is active low on the ESP-01)
  delay(500);                      // Wait for a second
  digitalWrite(pinn, HIGH);  // Turn the LED off by making the voltage HIGH
  delay(4000);








}
