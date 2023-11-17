import 'package:flutter/material.dart';
import 'package:garden_guard/components/garden_components.dart';
import 'package:garden_guard/garden_guard_src.dart';
import 'package:garden_guard/utils/util_widget.dart';

import 'package:get/get.dart';

part 'home_widget.dart';

class HomePage extends GetView<HomeCtrl> {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomeCtrl get controller => Get.find<HomeCtrl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            onPressed: () {
              controller.showAlert();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              bottom: false,
              child: GridView.builder(
                itemCount: GardenComponent.iconData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return _buildItem(index, controller);
                },
              ),
            ),
            if (controller.isLoading.value == true) ..._buildLoadingForm(),
          ],
        ),
      ),
    );
  }
}
