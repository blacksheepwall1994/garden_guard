import 'package:garden_guard/utils/box_value.dart';
import 'package:get_storage/get_storage.dart';

class BoxStorage {
  final box = GetStorage();

  bool get haveMqtt => box.read(BoxValue.haveMqtt) ?? false;

  String get boxUrl => box.read(BoxValue.boxUrl) ?? '';

  String get boxPort => box.read(BoxValue.boxPort) ?? '';

  String get boxUsername => box.read(BoxValue.boxUsername) ?? '';

  String get boxPassword => box.read(BoxValue.boxPassword) ?? '';

  String get boxTopic => box.read(BoxValue.boxTopic) ?? '';

  void setHaveMqtt(bool value) {
    box.write(BoxValue.haveMqtt, value);
  }

  void setBoxUrl(String value) {
    box.write(BoxValue.boxUrl, value);
  }

  void setBoxPort(String value) {
    box.write(BoxValue.boxPort, value);
  }

  void setBoxUsername(String value) {
    box.write(BoxValue.boxUsername, value);
  }

  void setBoxPassword(String value) {
    box.write(BoxValue.boxPassword, value);
  }

  void setBoxTopic(String value) {
    box.write(BoxValue.boxTopic, value);
  }

  void clear() {
    box.erase();
  }
}
