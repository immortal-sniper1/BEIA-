#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

#define pinn  D7
#define ADCC  A0



// WiFi
const char *ssid = "BEIA-WIFI-5G"; // Enter your WiFi name
const char *password = "gw4&^W^(T(&r3r892489";  // Enter WiFi password

const long utcOffsetInSeconds = 7200;   // time zone offset relative to UTC , in seconds
char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
// Define NTP Client to get time
WiFiUDP ntpUDP;     // UDP instance that is used for some functions
NTPClient timeClient(ntpUDP, "pool.ntp.org", utcOffsetInSeconds);



// MQTT Broker
const char *mqtt_broker = "mqtt.beia-telemetrie.ro";
const char *topic = "training/robi/esp8266test";
const char *topic2 = "training/robi/esp8266conter";
const char *topic3 = "training/robi/esp8266test2";
const char *mqtt_username = "";
const char *mqtt_password = "";
const int mqtt_port = 1883;
WiFiClient espClient;
PubSubClient client(espClient);
StaticJsonDocument<512> doc;



char eee[] = "{\"ttt\":44}";
int yy = 0;
int rr;
float qqw;
char tt[][200] =
{
  "Rage without focus is no weapon at all. Take this lesson back to the Blood God. - Lorgar, Primarch" ,
  "Foolish are those who fear nothing, yet claim to know everything. - Warhammer 40k, Imperium " ,
  "All power demands sacrifice... and pain. The universe rewards those willing to spill their life's blood for the promise of power. - Sindri Myr" ,
  "Fear the shadows; despise the night. There are horrors that no man can face and survive. - Codex: Dark Eldar" ,
  "For the foes of Mankind, the only mercy is a swift death. - Imperial Armour Volume Two" ,
  "A suspicious mind is a healthy mind. - Warhammer 40k, Imperium" ,
  "Even a man who has nothing can still offer his life. - Warhammer 40k, Imperium" ,
  "It is the duty of the Initiate to pass on what he has learned of the craft of death and thus paves the way for the heroes of the future. - Initiate Rammius" ,
  "Into the fires of battle! Unto the anvil of war! - Codex: Space Marines" ,
  "We ride upon the wings of the storm. What hope of escape can our foes have? - Spiccare, Sergeant" ,
  "Life is the Emperor's currency, spend it well. - Warhammer 40k, Imperium" ,
  "Show me a fortress and I'll show you a ruin. - Captain Edain Bourne, Warhammer 40k Seige, p. 105"
};
  float uvIntensity ;




void callback(char *topic, byte *payload, unsigned int length)
{
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
  Serial.print("Message:");
  for (int i = 0; i < length; i++)
  {
    Serial.print((char) payload[i]);
  }
  Serial.println();
  Serial.println("-----------------------");
}







void setup()
{
  // Set software serial baud to 115200;
  Serial.begin(115200);
  pinMode(pinn , OUTPUT);
  pinMode(ADCC , INPUT);

  WiFi.begin(ssid, password);

  while ( WiFi.status() != WL_CONNECTED ) {
    delay ( 500 );
    Serial.print ( "." );
  }











  // connecting to a WiFi network
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(15000);
    Serial.println("Connecting to WiFi..");
  }
  Serial.println("Connected to the WiFi network");
  //connecting to a mqtt broker
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
  while (!client.connected())
  {
    String client_id = "ROBERT: ";
    client_id += String(WiFi.macAddress());
    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());
    if (client.connect(client_id.c_str(), mqtt_username, mqtt_password))
    {
      Serial.println("Public emqx mqtt broker connected");
    }
    else
    {
      Serial.print("failed with state ");
      Serial.print(client.state());
      delay(2000);
    }
  }
  // publish and subscribe
  client.publish(topic, "THE EMPEROR PROTECTS");
  client.subscribe(topic);
  timeClient.begin();
}



//The Arduino Map function but for floats
//From: http://forum.arduino.cc/index.php?topic=3922.0
float mapfloat(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}










void loop()
{
  timeClient.update();
  Serial.print(daysOfTheWeek[timeClient.getDay()]);
  Serial.print(", ");
  Serial.print(timeClient.getHours());
  Serial.print(":");
  Serial.print(timeClient.getMinutes());
  Serial.print(":");
  Serial.println(timeClient.getSeconds());
  //Serial.println(timeClient.getFormattedTime());

  delay(1000);



  char sus_var[512] ;
  // itoa(yy, sus_var, 10);
  digitalWrite(pinn, HIGH);
  client.loop();
  Serial.println(yy);
  rr = random(0, 12);
  Serial.print("random: ");
  Serial.println(   rr  );



  qqw = analogRead(ADCC);
  Serial.print("TENSIUNE RAW: ");
  Serial.println(   qqw  );
  qqw = qqw * 3.33 / 1023;
  Serial.print("TENSIUNE [V]: ");
  Serial.println(   qqw  );
  uvIntensity = mapfloat(qqw, 0.99, 2.9, 0.0, 15.0);
  Serial.print(" UV Intensity (mW/cm^2): ");
  Serial.print(uvIntensity);  
  Serial.println();



  


  Serial.println(tt[rr]);
  client.publish(topic, tt[rr] );
  client.publish(topic3, eee );
  doc["sensor1"] = "fierbinte";
  doc["sensor2"] = 1351824120;
  doc["tensiune"] = qqw;
  doc["UV Intensity (mW/cm^2):"]= uvIntensity ;
  doc["40K"] = tt[rr];
  doc["Hours"] = timeClient.getHours();
  doc["Minutes"] = timeClient.getMinutes();
  doc["Seconds"] = timeClient.getSeconds();
  doc["time"] = timeClient.getFormattedTime();
  serializeJson(doc, sus_var);
  Serial.println("JSON: ");
  Serial.println(sus_var);
  client.publish(topic2, sus_var );
  delay(500);
  digitalWrite(pinn, LOW);




  Serial.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  //delay(500000);
  Serial.println("I'm awake, but I'm going into deep sleep mode for 300 seconds");
  ESP.deepSleep(30e7);












}
