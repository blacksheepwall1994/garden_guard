import 'package:flutter/material.dart';
import 'package:garden_guard/routes/routes.dart';
import 'package:garden_guard/utils/box.dart';
import 'package:get/get.dart';

class MqttCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController mqttUrl = TextEditingController();

  final TextEditingController mqttPort = TextEditingController()..text = '1883';

  final TextEditingController mqttUsername = TextEditingController();

  final TextEditingController mqttPassword = TextEditingController();

  final TextEditingController mqttTopic = TextEditingController();

  void saveMqtt() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    BoxStorage.setBoxUrl(mqttUrl.text.trim());

    BoxStorage.setBoxPort(mqttPort.text.trim());

    BoxStorage.setBoxUsername(mqttUsername.text.trim());

    BoxStorage.setBoxPassword(mqttPassword.text.trim());

    BoxStorage.setBoxTopic(mqttTopic.text.trim());

    BoxStorage.setHaveMqtt(true);

    Get.offNamed(Routes.home);
  }
}
