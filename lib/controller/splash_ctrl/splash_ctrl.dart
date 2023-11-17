import 'package:garden_guard/utils/box.dart';
import 'package:get/get.dart';

class SplashCtrl extends GetxController {
  @override
  void onInit() async{
    await checkMqtt();
    super.onInit();
  }

  Future<void> checkMqtt() async{
    await Future.delayed(const Duration(seconds: 2));
    if (BoxStorage().haveMqtt) {
      Get.offNamed('/home');
    } else {
      Get.offNamed('/mqtt');
    }
  }
}
