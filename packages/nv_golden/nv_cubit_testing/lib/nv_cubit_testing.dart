
import 'dart:async';

import 'package:flutter/services.dart';

class NvCubitTesting {
  static const MethodChannel _channel =
      const MethodChannel('nv_cubit_testing');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
