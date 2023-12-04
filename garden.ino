// #include "DHT.h"
// #include <WiFi.h>
// #include <PubSubClient.h>
// #include "ArduinoJson.h"
// #include <Wire.h>

// #define Addr 0x4A

// #define ssid "Tang 2.1"
// #define password "22222222"
// #define mqtt_server "test.mosquitto.org"

// const uint16_t mqtt_port = 1883; // Port của MQT

// #define DHTPIN1 18
// #define DHTPIN2 19
// #define lightSensor 32
// #define rainSensor 33
// #define waterSensor 26
// #define soilSensor1 25
// #define soilSensor2 16
// #define RELAY1 17
// #define RELAY2 14
// #define RELAY3 27

// #define soilWet 2000 // Define max value we consider soil 'wet'

// #define soilDry 4095 // Define min value we consider soil 'dry'

// #define maxValue 4095

// #define DHTTYPE DHT11

// DHT dht1(DHTPIN1, DHTTYPE);
// DHT dht2(DHTPIN2, DHTTYPE);

// bool motor1 = false;
// bool motor2 = false;
// bool isFanOn = false;
// int soil1 = 0;
// int soil2 = 0;
// bool isRain = false;
// bool isMorning = false;
// bool isWaterEmpty = false;
// bool isAuto = false;

// WiFiClient espClient;
// PubSubClient client(espClient);

// void setup()
// {

//     setup_wifi();                             // thực hiện kết nối Wifi
//     client.setServer(mqtt_server, mqtt_port); // cài đặt server và lắng nghe client ở port 1883
//     client.setCallback(callback);             // gọi hàm callback để thực hiện các chức năng publish/subcribe

//     if (!client.connected())
//     { // Kiểm tra kết nối
//         reconnect();
//     }
//     client.subscribe("garden_guard_quac");
//     client.subscribe("garden_guard_quac_send");

//     pinMode(soilSensor1, OUTPUT);
//     pinMode(soilSensor2, OUTPUT);
//     pinMode(lightSensor, OUTPUT);
//     pinMode(rainSensor, OUTPUT);
//     pinMode(waterSensor, OUTPUT);
//     pinMode(RELAY1, OUTPUT);
//     pinMode(RELAY2, OUTPUT);
//     pinMode(RELAY3, OUTPUT);

//     dht1.begin();
//     dht2.begin();

//     turnedOff();

//     Serial.begin(115200);
// }

// void turnedOff()
// {
//     digitalWrite(RELAY1, HIGH);
//     digitalWrite(RELAY2, HIGH);
//     digitalWrite(RELAY3, HIGH);
// }

// // Hàm kết nối wifi
// void setup_wifi()
// {
//     delay(10);
//     Serial.println();
//     Serial.print("Connecting to ");
//     Serial.println(ssid);
//     WiFi.begin(ssid, password);
//     while (WiFi.status() != WL_CONNECTED)
//     {
//         delay(500);
//         Serial.print(".");
//     }
//     Serial.println("");
//     Serial.println("WiFi connected");
//     Serial.println("IP address: ");
//     Serial.println(WiFi.localIP());
// }

// void callback(char *topic, byte *payload, unsigned int length)
// {
//     Serial.print("Co tin nhan moi tu topic: ");
//     Serial.println(topic);
//     char p[length + 1];
//     memcpy(p, payload, length);
//     p[length] = NULL;
//     String message(p);

//     if (String(topic) == "garden_guard_quac_send")
//     {
//         if (message == "RELAY1ON")
//         {
//             motor1 = true;
//             digitalWrite(RELAY1, LOW);
//         }
//         if (message == "RELAY2ON")
//         {
//             motor2 = true;
//             digitalWrite(RELAY2, LOW);
//         }
//         if (message == "RELAY3ON")
//         {
//             isFanOn = true;
//             digitalWrite(RELAY3, LOW);
//         }
//         if (message == "RELAY1OFF")
//         {
//             motor1 = false;
//             digitalWrite(RELAY1, HIGH);
//         }
//         if (message == "RELAY2OFF")
//         {
//             motor2 = false;
//             digitalWrite(RELAY2, HIGH);
//         }
//         if (message == "RELAY3OFF")
//         {
//             isFanOn = false;
//             digitalWrite(RELAY3, HIGH);
//         }
//         if (message == "AUTOON")
//         {
//             isAuto = true;
//         }
//         if (message == "AUTOOFF")
//         {
//             isAuto = false;
//         }
//     }

//     Serial.println(message);
//     // Serial.write(payload, length);
//     Serial.println();
//     //-------------------------------------------------------------------------
// }

// // Hàm reconnect thực hiện kết nối lại khi mất kết nối với MQTT Broker
// void reconnect()
// {
//     int randomNumber = random(100);
//     String myString1 = String(randomNumber);
//     while (!client.connected()) // Chờ tới khi kết nối
//     {
//         if (client.connect(myString1.c_str())) // kết nối vào broker
//         {
//             Serial.println("Đã kết nối:");
//             // đăng kí nhận dữ liệu từ topic
//             client.subscribe("garden_guard_quac");
//         }
//         else
//         {
//             // in ra trạng thái của client khi không kết nối được với broker
//             Serial.print("Lỗi:, rc=");
//             Serial.print(client.state());
//             Serial.println(" try again in 5 seconds");
//             // Đợi 5s
//             delay(5000);
//         }
//     }
// }

// long lastMsg = 0;

// int getStatusMoisture(int soilData)
// {
//     int soil = 0;
//     if (soilData < soilWet)
//     {
//         soil = 2;
//     }
//     else if (soilData >= soilWet && soilData < soilDry)
//     {
//         soil = 1;
//     }
//     return soil;
// }

// void loop()
// {
//     if (!client.connected())
//     { // Kiểm tra kết nối
//         Serial.println("Đã kết nối lại:");
//         reconnect();
//     }
//     client.loop();

//     long now = millis();
//     if (now - lastMsg > 2000)
//     {
//         lastMsg = now;
//         soil1 = analogRead(soilSensor1);
//         soil2 = analogRead(soilSensor2);

//         int soilMoisture1 = getStatusMoisture(soil1);
//         int soilMoisture2 = getStatusMoisture(soil2);

//         int h1 = dht1.readHumidity();
//         int t1 = dht1.readTemperature();

//         int h2 = dht2.readHumidity();
//         int t2 = dht2.readTemperature();

//         int rain = analogRead(rainSensor);
//         int water = analogRead(waterSensor);
//         int lux = analogRead(lightSensor);
//         if (lux == maxValue)
//         {
//             isMorning = false;
//         }
//         else
//         {
//             isMorning = true;
//         }

//         if (water == maxValue)
//         {
//             isWaterEmpty = false;
//         }
//         else
//         {
//             isWaterEmpty = true;
//         }
//         if (isAuto == true)
//         {
//             if (rain == maxValue)
//             {
//                 isRain = false;
//             }
//             else
//             {
//                 isRain = true;
//                 if (motor1 == true || motor2 == true)
//                 {
//                     motor1 = false;
//                     motor2 = false;
//                     digitalWrite(RELAY1, HIGH);
//                     digitalWrite(RELAY2, HIGH);
//                 }
//             }
//             if (t1 > 30 || t2 > 30)
//             {
//                 isFanOn = true;
//                 digitalWrite(RELAY3, LOW);
//             }
//             else
//             {
//                 isFanOn = false;
//                 digitalWrite(RELAY3, HIGH);
//             }
//         }
//         StaticJsonDocument<256> doc;

//         JsonObject dht1 = doc.createNestedObject("dht1");
//         dht1["temperature"] = t1;
//         dht1["humidity"] = h1;

//         JsonObject dht2 = doc.createNestedObject("dht2");
//         dht2["temperature"] = t2;
//         dht2["humidity"] = h2;
//         doc["motor1"] = motor1;
//         doc["motor2"] = motor2;
//         doc["fan"] = isFanOn;
//         doc["rainSensor"] = isRain;
//         doc["soilMoisture1"] = 1;
//         doc["soilMoisture2"] = 1;
//         doc["waterLevel"] = isWaterEmpty;
//         doc["lux"] = isMorning;
//         doc["auto"] = isAuto;

//         char buffer[256];
//         serializeJson(doc, buffer);
//         client.publish("garden_guard_quac", buffer);
//         // Serial.println(buffer);
//     }
// }