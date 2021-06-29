// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:nv_golden/nv_golden.dart';

import 'widget_wrapper.dart';

void main() {
  setUpAll(NvGolden.init);

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final nvWrapper = WidgetWrapper()..withMaterialApp();

    final nvGolden =
        NvGolden.devices(deviceSizes: [Device.iphone12pro, Device.iphone5s])
          ..addScenario(
            name: 'Full Page',
            widget: nvWrapper.wrap(MyHomePage(title: 'Test')),
          );

    await tester.createGolden(nvGolden, 'counter test');
  });
}
