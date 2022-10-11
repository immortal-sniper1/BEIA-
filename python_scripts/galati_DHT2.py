import serial
import time
import paho.mqtt.client as mqtt

serialPort = serial.Serial(    port="COM6", baudrate=4800, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

mqttBroker = 'beia.telemetrie.ro'
port = 1883
topic = "training/vital5g/DST-2/depth"
client_id = "NUC-navrom"
client = mqtt.Client(client_id)
client.connect(mqttBroker) 

serialString = ""  # Used to hold data coming over UART



while 1:
    # Wait until there is data waiting in the serial buffer
    if serialPort.in_waiting > 0:

        # Read data out of the buffer until a carraige return / new line is found
        serialString = serialPort.readline()

        # Print the contents of the serial data
        try:
            print(serialString.decode("Ascii"))

            # mqtt de bagat cam pe aici
            client.publish(topic, serialString)
        except:
            pass
