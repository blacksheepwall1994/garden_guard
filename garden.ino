#include "DHT.h"
#include <WiFi.h>
#include <PubSubClient.h>
#include "ArduinoJson.h"
#include <Wire.h>

#define Addr 0x4A

#define ssid "Tang 2.1"
#define password "22222222"
#define mqtt_server "test.mosquitto.org"

const uint16_t mqtt_port = 1883; // Port của MQT

#define DHTPIN1 18
#define DHTPIN2 19
#define LIGHT 32
#define RAIN 33
#define WATER 26
#define SOIL1 25
#define SOIL2 16
#define RELAY1 17
#define RELAY2 14
#define RELAY3 27

#define soilWet 500 // Define max value we consider soil 'wet'

#define soilDry 750 // Define min value we consider soil 'dry'

#define DHTTYPE DHT11

DHT dht1(DHTPIN1, DHTTYPE);
DHT dht2(DHTPIN2, DHTTYPE);

bool motor1 = false;
bool motor2 = false;
bool isLightOn = false;
int soil1 = 0;
int soil2 = 0;

WiFiClient espClient;
PubSubClient client(espClient);

void setup()
{
    Serial.begin(115200);

    setup_wifi();                             // thực hiện kết nối Wifi
    client.setServer(mqtt_server, mqtt_port); // cài đặt server và lắng nghe client ở port 1883
    client.setCallback(callback);             // gọi hàm callback để thực hiện các chức năng publish/subcribe

    if (!client.connected())
    { // Kiểm tra kết nối
        reconnect();
    }
    client.subscribe("garden_guard_quac");
    client.subscribe("garden_guard_quac_send");

    pinMode(LIGHT, OUTPUT);
    pinMode(RAIN, OUTPUT);
    pinMode(SOIL1, OUTPUT);
    pinMode(SOIL2, OUTPUT);
    pinMode(RELAY1, OUTPUT);
    pinMode(RELAY2, OUTPUT);
    pinMode(RELAY3, OUTPUT);

    dht1.begin();
    dht2.begin();

    turnedOff();
}

void turnedOff()
{
    digitalWrite(LIGHT, LOW);
    digitalWrite(RAIN, LOW);
    digitalWrite(SOIL1, LOW);
    digitalWrite(SOIL2, LOW);
    digitalWrite(RELAY1, LOW);
    digitalWrite(RELAY2, LOW);
    digitalWrite(RELAY3, LOW);
}

// Hàm kết nối wifi
void setup_wifi()
{
    delay(10);
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
}

void callback(char *topic, byte *payload, unsigned int length)
{
    Serial.print("Co tin nhan moi tu topic: ");
    Serial.println(topic);
    char p[length + 1];
    memcpy(p, payload, length);
    p[length] = NULL;
    String message(p);

    if (String(topic) == "garden_guard_quac_send")
    {
        if (message == "RELAY1ON")
        {
            motor1 = true;
            digitalWrite(RELAY1, HIGH);
        }
        if (message == "RELAY2ON")
        {
            motor2 = true;
            digitalWrite(RELAY2, HIGH);
        }
        if (message == "RELAY3ON")
        {
            isLightOn = true;
            digitalWrite(RELAY3, HIGH);
        }
        if (message == "RELAY1OFF")
        {
            motor1 = false;
            digitalWrite(RELAY1, LOW);
        }
        if (message == "RELAY2OFF")
        {
            motor2 = false;
            digitalWrite(RELAY2, LOW);
        }
        if (message == "RELAY3OFF")
        {
            isLightOn = false;
            digitalWrite(RELAY3, LOW);
        }
    }

    Serial.println(message);
    // Serial.write(payload, length);
    Serial.println();
    //-------------------------------------------------------------------------
}

// Hàm reconnect thực hiện kết nối lại khi mất kết nối với MQTT Broker
void reconnect()
{
    int randomNumber = random(100);
    String myString1 = String(randomNumber);
    while (!client.connected()) // Chờ tới khi kết nối
    {
        if (client.connect(myString1.c_str())) // kết nối vào broker
        {
            Serial.println("Đã kết nối:");
            // đăng kí nhận dữ liệu từ topic
            client.subscribe("garden_guard_quac");
        }
        else
        {
            // in ra trạng thái của client khi không kết nối được với broker
            Serial.print("Lỗi:, rc=");
            Serial.print(client.state());
            Serial.println(" try again in 5 seconds");
            // Đợi 5s
            delay(5000);
        }
    }
}

long lastMsg = 0;

void getStatusMoisture(int pin)
{
    int soil = 0;
    if (analogRead(pin) < soilWet)
    {
        soil = 2;
    }
    else if (analogRead(pin) >= soilWet && analogRead(pin) < soilDry)
    {
        soil = 1;
    }
    return soil;
}

void loop()
{

    // int soil1 = analogRead(SOIL1);
    // int soil2 = analogRead(SOIL2);
    int water = analogRead(WATER);
    int lux = digitalRead(LIGHT);
    int isRain = analogRead(RAIN);

    if (!client.connected())
    { // Kiểm tra kết nối
        Serial.println("Đã kết nối lại:");
        reconnect();
    }
    client.loop();

    long now = millis();
    if (now - lastMsg > 2000)
    {
        lastMsg = now;
        int h1 = dht1.readHumidity();
        int t1 = dht1.readTemperature();

        int h2 = dht2.readHumidity();
        int t2 = dht2.readTemperature();

        StaticJsonDocument<256> doc;

        JsonObject dht1 = doc.createNestedObject("dht1");
        dht1["temperature"] = t1;
        dht1["humidity"] = h1;

        JsonObject dht2 = doc.createNestedObject("dht2");
        dht2["temperature"] = t2;
        dht2["humidity"] = h2;
        doc["motor1"] = motor1;
        doc["motor2"] = motor2;
        doc["light"] = isLightOn;
        doc["rainSensor"] = isRain;
        doc["soilMoisture1"] = getStatusMoisture(SOIL1);
        doc["soilMoisture2"] = getStatusMoisture(SOIL2);
        doc["waterLevel"] = water;
        doc["lux"] = lux;
        char buffer[256];
        serializeJson(doc, buffer);
        client.publish("garden_guard_quac", buffer);
        Serial.println(buffer);

        delay(1000);
    }
}