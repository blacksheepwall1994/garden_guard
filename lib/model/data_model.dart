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
    this.lux = 0,
  });

  Dht? dht1;
  Dht? dht2;
  bool motor1;
  bool motor2;
  bool light;
  bool rainSensor;
  int soilMoisture1;
  int soilMoisture2;
  int waterLevel;
  int lux;

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
      lux: json["lux"] ?? 0,
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
        "lux": lux,
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
