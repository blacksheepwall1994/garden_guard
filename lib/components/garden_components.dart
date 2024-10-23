import 'package:flutter/material.dart';
import 'package:garden_guard/controller/home_ctrl/home_ctrl.dart';
import 'package:get/get.dart';

class GardenComponent {
  static const Map<int, Icon> iconData = {
    0: Icon(Icons.thermostat),
    1: Icon(Icons.gas_meter_outlined),
    2: Icon(Icons.slow_motion_video_outlined),
    3: Icon(Icons.door_front_door),
    4: Icon(Icons.wind_power),
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
