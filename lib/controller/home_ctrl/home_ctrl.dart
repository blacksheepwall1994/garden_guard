import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:garden_guard/components/garden_components.dart';
import 'package:garden_guard/garden_guard_src.dart';
import 'package:garden_guard/routes/routes.dart';
import 'package:get/get.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeCtrl extends GetxController {
  final client = MqttServerClient(
    BoxStorage.boxUrl,
    "${DateTime.now().millisecondsSinceEpoch.toString()}abcxyz12345",
  );

  WebSocketChannel? channel;

  RxBool isLoading = false.obs;

  RxBool isConnected = false.obs;

  RxBool ifOffline = false.obs;

  Rx<DataModel> dataModel = DataModel().obs;

  final image = Rx<Uint8List?>(null);
  // late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  // late final videoController = VideoController(player);
  late VlcPlayerController vlcViewController;

  @override
  void onInit() async {
    super.onInit();
    vlcViewController = VlcPlayerController.network(
      BoxStorage.boxVideoUrl,
      autoPlay: true,
      hwAcc: HwAcc.auto,
      options: VlcPlayerOptions(
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    await connect();
    await connectWebSocket();
  }

  @override
  void onClose() {
    // player.dispose();
    vlcViewController.dispose();
    super.dispose();
  }

  Future<void> connectWebSocket() async {
    try {
      // channel = IOWebSocketChannel.connect(Uri.parse(url));

      // await videoPlayerController.initialize();

      // vlcViewController.play();
      // player.open(Media(BoxStorage.boxVideoUrl), play: true);
      isConnected.value = true;
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
        ],
      );
    } on Exception catch (e) {
      logger.d(e);
    }
  }

  void publishUpdate() {
    publishMessage(
      payload: jsonEncode(
        dataModel.value.toJsonSend(),
      ),
    );
    update();
  }

  Future<void> connect() async {
    client.port = int.parse(BoxStorage.boxPort);
    client.logging(on: false);
    // client.secure = true;

    // /// Set the correct MQTT protocol for mosquito
    // client.setProtocolV311();
    // ByteData data = await rootBundle.load('cert/sheepu.crt');
    // SecurityContext context = SecurityContext.defaultContext;
    // context.setTrustedCertificatesBytes(data.buffer.asUint8List());

    // /// Set an on bad certificate callback, note that the parameter is needed.
    // client.onBadCertificate = (Object a) {
    //   logger.d(a);
    //   return true;
    // };

    client.keepAlivePeriod = 20;
    client.connectTimeoutPeriod = 2000;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(
          "${DateTime.now().millisecondsSinceEpoch.toString()}abcxyz12345",
        )
        .withWillQos(
          MqttQos.atLeastOnce,
        );
    client.connectionMessage = connMess;
    isLoading.value = true;
    try {
      await client.connect();
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
        final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        dataModel.value = DataModel.fromJson(jsonDecode(payload));
        logger.d(jsonDecode(payload));
        // logger.i('Received message:$payload from topic: ${c[0].topic}>');
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

  Future<void> publishMessage({
    required String payload,
  }) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    client.publishMessage(BoxStorage.boxTopicSend, MqttQos.atLeastOnce, builder.payload!);
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
// Bản tin như thế này ạ
// 2. App ----> Esp32
// topic: "2024/datn/app/esp"
// mở cửa là 1, đóng cửa là 0
// {
//     "door": 1,
//     "fan":0,
//     "light_1":0,
//     "light_2":0,
//     "light_3":0
// }