import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  filter: null,
  printer: kDebugMode ? PrettyPrinter() : null,
  output: null,
);
