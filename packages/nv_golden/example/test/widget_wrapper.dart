import 'package:flutter/material.dart';
import 'package:nv_golden/nv_golden.dart';

class WidgetWrapper extends NvWidgetWrapper {
  void withMaterialApp() => add((child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
      ));
}
