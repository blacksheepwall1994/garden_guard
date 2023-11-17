import 'package:garden_guard/model/soil_enum.dart';
import 'package:garden_guard/model/water_enum.dart';

class DataModel {
  DataModel({
    this.dht1,
    this.dht2,
    this.motor1 = false,
    this.motor2 = false,
    this.light = false,
    this.rainSensor = false,
    this.soilMoisture1 = 0,
    this.soilMoisture2 = 0,
    this.waterLevel = 0,
  });

  final Dht? dht1;
  final Dht? dht2;
  final bool motor1;
  final bool motor2;
  final bool light;
  final bool rainSensor;
  final int soilMoisture1;
  final int soilMoisture2;
  final int waterLevel;

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      dht1: json["dht1"] == null ? null : Dht.fromJson(json["dht1"]),
      dht2: json["dht2"] == null ? null : Dht.fromJson(json["dht2"]),
      motor1: json["motor1"] ?? false,
      motor2: json["motor2"] ?? false,
      light: json["light"] ?? false,
      rainSensor: json["rainSensor"] ?? false,
      soilMoisture1: json["soilMoisture1"] ?? SoilStatus.normal,
      soilMoisture2: json["soilMoisture2"] ?? SoilStatus.normal,
      waterLevel: json["waterLevel"] ?? WaterEnum.low,
    );
  }

  Map<String, dynamic> toJson() => {
        "dht1": dht1?.toJson(),
        "dht2": dht2?.toJson(),
        "motor1": motor1,
        "motor2": motor2,
        "light": light,
        "rainSensor": rainSensor,
        "soilMoisture1": soilMoisture1,
        "soilMoisture2": soilMoisture2,
        "waterLevel": waterLevel,
      };
}

class Dht {
  Dht({
    this.temperature = 0,
    this.humidity = 0,
  });

  final int temperature;
  final int humidity;

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
