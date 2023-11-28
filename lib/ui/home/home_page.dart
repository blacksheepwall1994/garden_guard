import 'dart:convert';
import 'dart:typed_data';

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
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: controller.isConnected.value
                        ? StreamBuilder(
                            stream: controller.channel!.stream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return const Center(
                                  child: Text("Đã đóng kết nối"),
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(
                                  Uint8List.fromList(
                                    base64Decode(
                                      (snapshot.data.toString()),
                                    ),
                                  ),
                                  gaplessPlayback: true,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          )
                        : const Text("Kết nối không ổn định"),
                  ),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: GardenComponent.iconData.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return _buildItem(index, controller);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value == true) ..._buildLoadingForm(),
          ],
        ),
      ),
    );
  }
}
