#include <ArduinoJson.h>

#include <ESP8266WiFi.h>
#include <PubSubClient.h>

#define pinn  D7
#define ADCC  A0

// WiFi
const char *ssid = "LANCOMBEIA"; // Enter your WiFi name
const char *password = "beialancom";  // Enter WiFi password
//const char *ssid = "AndroidAP41F72"; // Enter your WiFi name
//const char *password = "hsia8997";  // Enter WiFi password

// MQTT Broker
const char *mqtt_broker = "mqtt.beia-telemetrie.ro";
const char *topic = "training/robi/esp8266test";
const char *topic2 = "training/robi/esp8266conter";
const char *topic3 = "training/robi/esp8266test2";
const char *mqtt_username = "";
const char *mqtt_password = "";
const int mqtt_port = 1883;

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

WiFiClient espClient;
PubSubClient client(espClient);
StaticJsonDocument<512> doc;

char eee[] = "{\"ttt\":44}";








void setup()
{
  // Set software serial baud to 115200;
  Serial.begin(115200);
  pinMode(pinn , OUTPUT);
  pinMode(ADCC , INPUT);




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
    String client_id = "esp8266-client-";
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
}













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






void loop()
{
  Serial.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  yy++;
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
  Serial.println(tt[rr]);



  Serial.println(tt[rr]);
  client.publish(topic, tt[rr] );
  client.publish(topic3, eee );




  doc["sensor1"] = "fierbinte";
  doc["sensor2"] = 1351824120;
  doc["tensiune"] = qqw;

  /*
    JsonArray data = doc.createNestedArray("data");
    data.add(48.75608);
    data.add(2.302038);

  */
  doc["40K"] = tt[rr];
  doc["count"] = yy;
  serializeJson(doc, sus_var);
  Serial.println("JSON: ");
  Serial.println(sus_var);



  client.publish(topic2, sus_var );
  delay(500);


  digitalWrite(pinn, LOW);
  delay(10000);
  Serial.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");

}
