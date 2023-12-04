import 'package:garden_guard/model/soil_enum.dart';

class DataModel {
  DataModel({
    this.dht1,
    this.dht2,
    this.motor1 = false,
    this.motor2 = false,
    this.fan = false,
    this.rainSensor = false,
    this.soilMoisture1 = 0,
    this.soilMoisture2 = 0,
    this.waterLevel = false,
    this.lux = 0,
    this.isAuto = false,
  });

  Dht? dht1;
  Dht? dht2;
  bool motor1;
  bool motor2;
  bool fan;
  bool rainSensor;
  int soilMoisture1;
  int soilMoisture2;
  bool waterLevel;
  int lux;
  bool isAuto;

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      dht1: json["dht1"] == null ? null : Dht.fromJson(json["dht1"]),
      dht2: json["dht2"] == null ? null : Dht.fromJson(json["dht2"]),
      motor1: json["motor1"] ?? false,
      motor2: json["motor2"] ?? false,
      fan: json["fan"] ?? false,
      rainSensor: json["rainSensor"] ?? false,
      soilMoisture1: json["soilMoisture1"] ?? SoilStatus.normal,
      soilMoisture2: json["soilMoisture2"] ?? SoilStatus.normal,
      waterLevel: json["waterLevel"] ?? false,
      lux: json["lux"] ?? 0,
      isAuto: json["isAuto"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "dht1": dht1?.toJson(),
        "dht2": dht2?.toJson(),
        "motor1": motor1,
        "motor2": motor2,
        "fan": fan,
        "rainSensor": rainSensor,
        "soilMoisture1": soilMoisture1,
        "soilMoisture2": soilMoisture2,
        "waterLevel": waterLevel,
        "lux": lux,
        "isAuto": isAuto,
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
