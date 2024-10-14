#!/usr/bin/python3
import os
import paho.mqtt.client as mqtt

mqtt_broker = str(os.environ.get("MQTT_BROKER", "mqtt.eclipseprojects.io"))
mqtt_broker_port = int(os.environ.get("MQTT_BROKER_PORT", 1883))
mqtt_broker_timeout = int(os.environ.get("MQTT_BROKER_TIMEOUT", 60))


# The callback for when the client receives a CONNACK response from the server.
def on_connect_cb(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("/bb_paho_test/#")


# The callback for when a PUBLISH message is received from the server.
def on_message_cb(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))
    if "system/control" in msg.topic:
        command = msg.payload.decode("UTF-8")
        match command:
            case "reboot":
                os.system("reboot")
            case "poweroff":
                os.system("poweroff")
            case _:
                print("Unknown command")


mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect_cb
mqttc.on_message = on_message_cb

mqttc.connect(mqtt_broker, mqtt_broker_port, mqtt_broker_timeout)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
mqttc.loop_forever()
