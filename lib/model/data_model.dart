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
  double temperature;
  int gas;
  int motion;

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      temperature: json["temperature"] ?? 0.0,
      motion: json["motion"] ?? 0,
      gas: json["gas"] ?? 0,
    )
      ..fan.value = json["fan"] ?? false
      ..door.value = json["door"] ?? false;
  }

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "fan": fan.value,
        "door": door.value,
        "gas": gas,
        "motion": motion,
      };

  Map<String, dynamic> toJsonSend() => {
        "fan": fan.value ? 1 : 0,
        "door": door.value ? 1 : 0,
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
