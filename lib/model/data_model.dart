import 'package:get/get.dart';

class DataModel {
  DataModel({
    // this.fan,
    this.temperature = 0.0,
    this.gas = 0,
    this.motion = 0,
  });

  RxBool fan = false.obs;
  RxBool door = false.obs;
  RxBool light1 = false.obs;
  RxBool light2 = false.obs;
  RxBool light3 = false.obs;
  double temperature;
  int gas;
  int motion;

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      temperature: json["temperature"] ?? 0.0,
      motion: json["motion"] ?? 0,
      gas: json["gas"] ?? 0,
    )
      ..fan.value = json["fan"] == 1 
      ..door.value = json["door"] == 1;
  }

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "fan": fan.value,
        "door": door.value,
        "gas": gas,
        "motion": motion,
        "light_1": light1.value ? 1 : 0,
        "light_2": light2.value ? 1 : 0,
        "light_3": light3.value ? 1 : 0,
      };

  Map<String, dynamic> toJsonSend() => {
        "fan": fan.value ? 1 : 0,
        "door": door.value ? 1 : 0,
        "light_1": light1.value ? 1 : 0,
        "light_2": light2.value ? 1 : 0,
        "light_3": light3.value ? 1 : 0,
      };
}

class Dht {
  Dht({
    this.temperature = 0,
    this.humidity = 0,
  });

  int temperature;
  int humidity;

  factory Dht.fromJson(Map<String, dynamic> json) {
    return Dht(
      temperature: json["temperature"] ?? 0,
      humidity: json["humidity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "humidity": humidity,
      };
}
