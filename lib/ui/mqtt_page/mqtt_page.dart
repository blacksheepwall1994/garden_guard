import 'package:flutter/material.dart';
import 'package:garden_guard/controller/mqtt_ctrl/mqtt_ctrl.dart';
import 'package:get/get.dart';

class MqttPage extends GetView<MqttCtrl> {
  const MqttPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('MqttPage is working'),
      ),
    );
  }
}
