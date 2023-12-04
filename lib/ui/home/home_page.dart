import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garden_guard/components/garden_components.dart';
import 'package:garden_guard/garden_guard_src.dart';
import 'package:garden_guard/utils/util_widget.dart';
import 'package:get/get.dart';

part 'home_widget.dart';

class HomePage extends GetResponsiveView<HomeCtrl> {
  HomePage({
    super.key,
    super.alwaysUseBuilder = false,
  });

  @override
  HomeCtrl get controller => Get.find<HomeCtrl>();

  @override
  Widget? phone() {
    return screen.context.isLandscape
        ? _buildBodyLandscape(controller)
        : _buildBodyPortrait(controller);
  }
}
