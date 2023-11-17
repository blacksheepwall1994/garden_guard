import 'package:garden_guard/controller/splash_ctrl/splash_ctrl.dart';
import 'package:garden_guard/ui/home/home_page.dart';
import 'package:garden_guard/ui/mqtt_page/mqtt_page.dart';
import 'package:garden_guard/ui/splash/splash_page.dart';
import 'package:get/get.dart';

import '../controller/home_ctrl/home_ctrl.dart';

abstract class Routes {
  static const home = '/home';
  static const splash = '/splash';
  static const mqtt = '/mqtt';
}

abstract class AppPages {
  static String initial = Routes.splash;
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder.put(
        () => HomeCtrl(),
      ),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder.put(
        () => SplashCtrl(),
      ),
    ),
    GetPage(
      name: Routes.mqtt,
      page: () => const MqttPage(),
      binding: BindingsBuilder.put(
        () => SplashCtrl(),
      ),
    ),
  ];
}
