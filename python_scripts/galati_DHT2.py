import serial
import time
import paho.mqtt.client as mqtt
import json

serialPort = serial.Serial(    port="COM6", baudrate=4800, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

mqttBroker = 'mqtt.beia-telemetrie.ro'
port = 1883
topic = "training/vital5g/DST-2/depth"
client_id = "NUC-navrom"
client = mqtt.Client(client_id)
client.connect(mqttBroker) 

serialString = ""  # Used to hold data coming over UART

# while(1):
#     client.publish(topic, "77")
#     time.sleep(30)


while 1:
    # Wait until there is data waiting in the serial buffer
    if serialPort.in_waiting > 0:

        # Read data out of the buffer until a carraige return / new line is found
        serialString = serialPort.readline()

        # Print the contents of the serial data
        try:
            print(serialString.decode("Ascii"))

            # mqtt de bagat cam pe aici
            lungg=len(serialString)
            smgg=serialString[lungg-20:lungg-17]
            smgg2=serialString[lungg-18:lungg-15]
            #nn=int(smgg)
            print( "smgg= ", end = ' ' )
            print( smgg )
            print( "smgg2= ", end = ' ' )
            print(  smgg2 )
            outputt= smgg.decode()
            outputt2= smgg2.decode()
            print(outputt[:1])
            print(outputt2[:1])
            #ss2='{"id":"ceva","value":' + int(outputt2) + '}'
            myJSON_test=json.dumps({"id":"GalatiPonton1","value":outputt2 })
            json.dumps(["apple", 731])
            #print(ss2)
            print(  "grwtwtwtwetwet-----------------------------" )
            #if outputt[:1]!="f" or  outputt[:1].isnumeric()    :
            #client.publish(topic, outputt2   )
            client.publish(topic,  myJSON_test  )
            print(  "upssss2" )


            time.sleep(5)

        except:
            pass
