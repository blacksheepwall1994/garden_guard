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
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Icon(
              GardenComponent.iconData[index]?.icon,
              color: Colors.blue.withOpacity(0.4),
              size: 80,
            ),
          ),
          _buildDataSensor(index, controller).paddingAll(12),
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

String getStatusLightSensor(bool value) {
  if (value == true) {
    return "Đang bật";
  } else {
    return "Đang tắt";
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
  final dataModel = controller.dataModel.value;
  switch (index) {
    case 0:
      return UtilWidget.buildText("Nhiệt độ: ${controller.dataModel.value.temperature}");
    case 1:
      return UtilWidget.buildText('Gas: ${controller.dataModel.value.gas}');
    case 2:
      return UtilWidget.buildText(
        controller.dataModel.value.motion == 0 ? "Không có chuyển động" : "Có chuyển động",
      );
    case 3:
      return buildSwitchControl(
        label: "Cửa: ${getStatusSensor(dataModel.door.value)}",
        value: dataModel.door.value,
        onChanged: (value) {
          dataModel.door.value = value;
          controller.publishUpdate();
        },
      );
    case 4:
      return buildSwitchControl(
        label: "Quạt: ${getStatusSensor(dataModel.fan.value)}",
        value: dataModel.fan.value,
        onChanged: (value) {
          dataModel.fan.value = value;
          controller.publishUpdate();
        },
      );
    case 5:
      return buildSwitchControl(
        label: "Đèn 1: ${getStatusLightSensor(dataModel.light1.value)}",
        value: dataModel.light1.value,
        onChanged: (value) {
          dataModel.light1.value = value;
          controller.publishUpdate();
        },
      );
    case 6:
      return buildSwitchControl(
        label: "Đèn 2: ${getStatusLightSensor(dataModel.light2.value)}",
        value: dataModel.light2.value,
        onChanged: (value) {
          dataModel.light2.value = value;
          controller.publishUpdate();
        },
      );
    case 7:
      return buildSwitchControl(
        label: "Đèn 3: ${getStatusLightSensor(dataModel.light3.value)}",
        value: dataModel.light3.value,
        onChanged: (value) {
          dataModel.light3.value = value;
          controller.publishUpdate();
        },
      );
    default:
      return UtilWidget.buildText("Lỗi đọc dữ liệu");
  }
}

Widget buildSwitchControl({
  required String label,
  required bool value,
  required Function(bool) onChanged,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Switch(value: value, onChanged: onChanged),
      UtilWidget.buildText(label),
    ],
  );
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
