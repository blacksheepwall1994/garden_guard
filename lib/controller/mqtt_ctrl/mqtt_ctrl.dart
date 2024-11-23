import 'package:flutter/material.dart';
import 'package:garden_guard/routes/routes.dart';
import 'package:garden_guard/utils/box.dart';
import 'package:get/get.dart';

class MqttCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController mqttUrl = TextEditingController()..text = 'broker.mqtt.cool';

  final TextEditingController mqttPort = TextEditingController()..text = '1883';

  final TextEditingController mqttUsername = TextEditingController();

  final TextEditingController mqttPassword = TextEditingController();

  final TextEditingController videoUrl = TextEditingController()..text = 'http://192.168.0.102:8080/video_feed';

  final TextEditingController mqttTopic = TextEditingController()..text = '2024/datn/esp/app';
  final TextEditingController mqttTopicSend = TextEditingController()..text = '2024/datn/app/esp';

  void saveMqtt() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    BoxStorage.setBoxUrl(mqttUrl.text.trim());

    BoxStorage.setBoxPort(mqttPort.text.trim());

    BoxStorage.setBoxUsername(mqttUsername.text.trim());

    BoxStorage.setBoxPassword(mqttPassword.text.trim());

    BoxStorage.setBoxTopic(mqttTopic.text.trim());

    BoxStorage.setBoxTopicSend(mqttTopicSend.text.trim());

    BoxStorage.setVideoUrl(videoUrl.text.trim());

    BoxStorage.setHaveMqtt(true);

    Get.offNamed(Routes.home);
  }
}
