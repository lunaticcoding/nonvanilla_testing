import 'package:example/components/delete_icon.dart';
import 'package:example/details_page.dart';
import 'package:example/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/models/nv_gesture.dart';

import 'nonvanilla_testing.dart';

void main() {
  setUpAll(NvGolden.init);

  group('Devices', () {
    testWidgets('check devices - Main Page', (tester) async {
      final wrapper = NvWrapper()..withMaterialApp();

      final nvGolden = NvGolden.devices(deviceSizes: [
        Device.iphone5s,
        Device.iphone12pro,
        Device.iphone12proMax,
      ])
        ..addScenario(
          name: 'Title',
          widget: wrapper.wrap(MainPage()),
        );
      await tester.createGolden(nvGolden, 'devices/main_page');
    });

    testWidgets('check devices - Details Page', (tester) async {
      final wrapper = NvWrapper()..withMaterialApp();

      final nvGolden = NvGolden.devices(deviceSizes: [
        Device.iphone5s,
        Device.iphone12pro,
        Device.iphone12proMax,
      ])
        ..addScenario(
          name: 'Title',
          widget: wrapper.wrap(
            DetailsPage(
              entry: Entry(text: 'Test text', state: CheckState.inProgress),
            ),
          ),
        );
      await tester.createGolden(nvGolden, 'devices/details_page');
    });
  });

  group('Interaction', () {
    testWidgets('Main Page', (tester) async {
      final nvGolden = NvGolden.singular(
        screen: Device.iphone12pro,
        widget: MainPage(),
      );

      await tester.createSequenceGolden(
        nvGolden,
        'interaction/main_page_delete/1',
        gestures: [
          NvGestureTap(
            finder: () => find.byType(DeleteIcon).at(1),
            apply: true,
          ),
        ],
      );

      await tester.createSequenceGolden(
        nvGolden,
        'interaction/main_page_delete/2',
        gestures: [],
      );
    });

    testWidgets('Details Page', (tester) async {
      final nvGolden = NvGolden.singular(
        screen: Device.iphone12pro,
        widget: DetailsPage(
          entry: Entry(text: 'Test text', state: CheckState.inProgress),
        ),
      );

      await tester.createSequenceGolden(
        nvGolden,
        'interaction/details_page_drag/1',
        gestures: [
          NvGestureDrag(
            finder: () => find.byType(Image).at(1),
            offset: Offset(-100, 0),
          ),
        ],
      );

      await tester.createSequenceGolden(
        nvGolden,
        'interaction/details_page_drag/2',
        gestures: [],
      );
    });
  });
}
