import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:garden_guard/components/garden_components.dart';
import 'package:garden_guard/garden_guard_src.dart';
import 'package:garden_guard/utils/util_widget.dart';
import 'package:get/get.dart';

part 'home_widget.dart';

class HomePage extends GetView<HomeCtrl> {
  const HomePage({super.key});

  @override
  HomeCtrl get controller => Get.find<HomeCtrl>();

  @override
  Widget build(BuildContext context) {
    return _buildBodyPortrait(controller);
  }
}
