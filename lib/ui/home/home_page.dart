import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garden_guard/components/garden_components.dart';
import 'package:garden_guard/garden_guard_src.dart';
import 'package:garden_guard/utils/util_widget.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

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
