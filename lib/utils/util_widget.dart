import 'package:flutter/material.dart';

class UtilWidget {
  static Widget buildText(String title) {
    return Text(
      title,
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }
}
