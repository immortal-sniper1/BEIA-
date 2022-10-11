import time
import paho.mqtt.client as mqtt

serialPort = serial.Serial(    port="COM6", baudrate=4800, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

mqttBroker = 'beia.telemetrie.ro'
port = 1883
topic = "training/vital5g/DST-2/depth"
client_id = "NUC-navrom"
client = mqtt.Client(client_id)
client.connect(mqttBroker) 


while 1:

    client.publish(topic, 50)

