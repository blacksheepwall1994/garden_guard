import 'dart:io';

import 'package:garden_guard/utils/logger.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeCtrl extends GetxController {
  final client = MqttServerClient('broker.mqttdashboard.com', '');
  @override
  void onInit() async {
    await connect();
    super.onInit();
  }

  Future<void> connect() async {
    client.port = 1883;
    client.logging(on: true);
    client.keepAlivePeriod = 120;
    client.connectTimeoutPeriod = 2000;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(DateTime.now().millisecondsSinceEpoch.toString())
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }
  }

  void onConnected() {
    logger.i('Connected');
  }

  void onDisconnected() {
    logger.i('Disconnected');
  }

  void onSubscribed(String topic) {
    client.subscribe("guarden_guard_quac", MqttQos.atMostOnce);
  }
}
