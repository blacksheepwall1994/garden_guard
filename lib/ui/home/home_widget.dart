part of 'home_page.dart';

List<Widget> _buildLoadingForm() {
  return [
    const Opacity(
      opacity: 0.8,
      child: ModalBarrier(dismissible: false, color: Colors.black),
    ),
    const Center(
      child: CircularProgressIndicator(),
    ),
  ];
}

Widget _buildDHTSensor(double temperature) {
  return UtilWidget.buildText(
    "Nhiệt độ: ${temperature.toString()}",
  );
}

Widget _buildItem(int index, HomeCtrl controller) {
  return Container(
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey.withOpacity(0.5),
      ),
    ),
    child: Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Icon(
              GardenComponent.iconData[index]?.icon,
              color: Colors.blue.withOpacity(0.4),
              size: 80,
            ),
          ),
          _buildDataSensor(index, controller),
        ],
      ),
    ),
  );
}

String getStatusSensor(bool value) {
  if (value == true) {
    return "Đang mở";
  } else {
    return "Đang đóng";
  }
}

String getSoilData(int value) {
  switch (SoilStatus.values[value]) {
    case SoilStatus.normal:
      return "Bình thường";
    case SoilStatus.wet:
      return "Đang ẩm";
    case SoilStatus.dry:
      return "Đang khô, cần tưới nước";
    default:
      return "Lỗi";
  }
}

String getWaterLevel(int value) {
  switch (WaterEnum.values[value]) {
    case WaterEnum.low:
      return "Thấp";
    case WaterEnum.medium:
      return "Trung bình";
    case WaterEnum.high:
      return "Cao";
    default:
      return "Lỗi";
  }
}

Widget _buildDataSensor(int index, HomeCtrl controller) {
  switch (index) {
    case 0:
      return _buildDHTSensor(controller.dataModel.value.temperature);
    case 1:
      return UtilWidget.buildText('Gas: ${controller.dataModel.value.gas}');
    case 2:
      return UtilWidget.buildText(
        controller.dataModel.value.motion == 0 ? "Không có chuyển động" : "Có chuyển động",
      );
    case 3:
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(
            value: controller.dataModel.value.door.value,
            onChanged: (value) {
              controller.dataModel.value.door.value = value;
              controller.publishMessage(
                payload: jsonEncode(
                  controller.dataModel.value.toJsonSend(),
                ),
              );
              controller.update();
            },
          ),
          UtilWidget.buildText("Cửa : ${getStatusSensor(controller.dataModel.value.door.value)}"),
        ],
      );
    case 4:
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(
            value: controller.dataModel.value.fan.value,
            onChanged: (value) {
              controller.dataModel.value.fan.value = value;
              controller.publishMessage(
                payload: jsonEncode(
                  controller.dataModel.value.toJsonSend(),
                ),
              );
              controller.update();
            },
          ),
          UtilWidget.buildText("Quạt: ${getStatusSensor(controller.dataModel.value.fan.value)}"),
        ],
      );
    default:
      return UtilWidget.buildText("Lỗi đọc dữ liệu");
  }
}

Widget _buildBodyPortrait(HomeCtrl controller) {
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
    body: SafeArea(
      bottom: false,
      child: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await controller.vlcViewController.stop();
            await controller.vlcViewController.play();
            // await controller.videoController.player.open(Media(BoxStorage.boxVideoUrl));
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: controller.isConnected.value
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: VlcPlayer(
                              controller: controller.vlcViewController,
                              // fit: BoxFit.cover,
                              aspectRatio: 16 / 9,
                            ),
                          ).paddingAll(10)
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 2,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: GardenComponent.iconData.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return _buildItem(index, controller);
                      },
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value == true) ..._buildLoadingForm(),
            ],
          ),
        ),
      ),
    ),
  );
}
