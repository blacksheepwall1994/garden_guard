import 'dart:convert';
import 'dart:io';

import 'package:garden_guard/components/garden_components.dart';
import 'package:garden_guard/model/data_model.dart';
import 'package:garden_guard/routes/routes.dart';
import 'package:garden_guard/utils/box.dart';
import 'package:garden_guard/utils/logger.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeCtrl extends GetxController {
  final client = MqttServerClient(BoxStorage.boxUrl, '');
  late final WebSocketChannel? channel;
  static const String url = "ws://192.168.0.101:3000";

  RxBool isLoading = false.obs;
  RxBool isConnected = false.obs;
  Rx<DataModel> dataModel = DataModel().obs;

  @override
  void onInit() async {
    await connect();
    connectWebSocket();
    super.onInit();
  }

  void connectWebSocket() {
    channel = IOWebSocketChannel.connect(Uri.parse(url));
    isConnected.value = true;
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
    Get.showSnackbar(const GetSnackBar(
      title: 'Kết nối thành công',
      message: 'Đã kết nối thành công tới broker',
      duration: Duration(seconds: 3),
    ));

    isLoading.value = false;
    client.subscribe(BoxStorage.boxTopic, MqttQos.atLeastOnce);
    client.updates?.listen(
      (List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        dataModel.value = DataModel.fromJson(jsonDecode(payload));
        logger.i('Received message:$payload from topic: ${c[0].topic}>');
      },
    );
  }

  void onDisconnected() {
    logger.i('Disconnected');
    Get.offNamed(Routes.mqtt);
    Get.showSnackbar(
      const GetSnackBar(
        title: 'Lỗi kết nối',
        message: 'Xin hãy kiểm tra lại url hoặc mạng',
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> publishMessage() async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode(dataModel.value));
    client.publishMessage(
        BoxStorage.boxTopic, MqttQos.atLeastOnce, builder.payload!);
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
