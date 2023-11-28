// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:garden_guard/utils/logger.dart';

// class Connectivity{
//   static  Connectivity connectivity = Connectivity();

//   late StreamSubscription<ConnectivityResult> subscription;
//   void initState() {
//     initConnectivity();

//     subscription =
//         connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }
//   Future<void> initConnectivity() async {
//     late ConnectivityResult result;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       logger.d('Couldn\'t check connectivity status', error: e);
//       return;
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) {
//       return Future.value(null);
//     }

//     return _updateConnectionStatus(result);
//   }
// }