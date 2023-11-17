import 'dart:convert';
import 'dart:io';

import 'package:garden_guard/components/garden_components.dart';
import 'package:garden_guard/model/data_model.dart';
import 'package:garden_guard/utils/box.dart';
import 'package:garden_guard/utils/logger.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeCtrl extends GetxController {
  late final client = MqttServerClient(BoxStorage.boxUrl, '');
  RxBool isLoading = false.obs;
  Rx<DataModel> dataModel = DataModel().obs;

  @override
  void onInit() async {
    BoxStorage.getAllData();
    await connect();
    super.onInit();
  }

  Future<void> connect() async {
    client.port = int.parse(BoxStorage.boxPort);
    client.logging(on: true);
    client.secure = false;
    client.keepAlivePeriod = 20;
    client.connectTimeoutPeriod = 2000;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(DateTime.now().millisecondsSinceEpoch.toString())
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;
    isLoading.value = true;
    try {
      await client.connect(BoxStorage.boxUsername, BoxStorage.boxPassword);
    } on NoConnectionException catch (e) {
      logger.i('client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      logger.i('EXAMPLE::socket exception - $e');
      client.disconnect();
    }
  }

  void onConnected() {
    logger.i('Connected');
    isLoading.value = false;
    client.subscribe(BoxStorage.boxTopic, MqttQos.atLeastOnce);
    client.updates?.listen(
      (List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        dataModel.value = DataModel.fromJson(jsonDecode(payload));
        logger.i(dataModel.value.dht1?.humidity);
        logger.i('Received message:$payload from topic: ${c[0].topic}>');
      },
    );
  }

  void onDisconnected() {
    logger.i('Disconnected');
  }

  Future<void> logOut() async {
    client.disconnect();
    BoxStorage.clear();
    Get.offAllNamed('/mqtt');
  }

  Future<void> showAlert() async {
    Get.dialog(GardenComponent.showDialog(this));
  }
}
