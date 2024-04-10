import 'package:garden_guard/model/soil_enum.dart';
import 'package:get/get.dart';

class DataModel {
  DataModel({
    this.dht1,
    this.dht2,
    // this.motor1 = false,
    // this.motor2 = false,
    // this.fan = false,
    this.rainSensor = false,
    this.soilMoisture1 = 0,
    this.soilMoisture2 = 0,
    this.waterLevel = false,
    this.lux = false,
    // this.isAuto = false,
  });

  Dht? dht1;
  Dht? dht2;
  RxBool motor1 = false.obs;
  RxBool motor2 = false.obs;
  RxBool fan = false.obs;
  bool rainSensor;
  int soilMoisture1;
  int soilMoisture2;
  bool waterLevel;
  bool lux;
  RxBool isAuto = false.obs;

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      dht1: json["dht1"] == null ? null : Dht.fromJson(json["dht1"]),
      dht2: json["dht2"] == null ? null : Dht.fromJson(json["dht2"]),
      // motor1: json["motor1"] ?? false,
      // motor2: json["motor2"] ?? false,
      // fan: json["fan"] ?? false,
      rainSensor: json["rainSensor"] ?? false,
      soilMoisture1: json["soilMoisture1"] ?? SoilStatus.normal,
      soilMoisture2: json["soilMoisture2"] ?? SoilStatus.normal,
      waterLevel: json["waterLevel"] ?? false,
      lux: json["lux"] ?? false,
      // isAuto: json["isAuto"] ?? false,
    )
      ..motor1.value = json["motor1"] ?? false
      ..motor2.value = json["motor2"] ?? false
      ..fan.value = json["fan"] ?? false
      ..isAuto.value = json["isAuto"] ?? false;
  }

  Map<String, dynamic> toJson() => {
        "dht1": dht1?.toJson(),
        "dht2": dht2?.toJson(),
        "motor1": motor1.value,
        "motor2": motor2.value,
        "fan": fan.value,
        "rainSensor": rainSensor,
        "soilMoisture1": soilMoisture1,
        "soilMoisture2": soilMoisture2,
        "waterLevel": waterLevel,
        "lux": lux,
        "isAuto": isAuto.value,
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
