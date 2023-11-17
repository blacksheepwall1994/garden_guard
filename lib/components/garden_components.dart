import 'package:flutter/material.dart';
import 'package:garden_guard/controller/home_ctrl/home_ctrl.dart';
import 'package:get/get.dart';

class GardenComponent {
  static const Map<int, Icon> iconData = {
    0: Icon(Icons.thermostat),
    1: Icon(Icons.thermostat),
    2: Icon(Icons.shower),
    3: Icon(Icons.shower),
    4: Icon(Icons.lightbulb),
    5: Icon(Icons.thunderstorm),
    6: Icon(Icons.grass),
    7: Icon(Icons.grass),
    8: Icon(Icons.water),
    9: Icon(Icons.lightbulb_circle),
  };
  static Widget showDialog(HomeCtrl controller) {
    return AlertDialog(
      title: const Text('Thông báo'),
      content: const Text('Bạn có muốn đăng xuất không?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Không'),
        ),
        TextButton(
          onPressed: () {
            controller.logOut();
          },
          child: const Text('Có'),
        ),
      ],
    );
  }
}
