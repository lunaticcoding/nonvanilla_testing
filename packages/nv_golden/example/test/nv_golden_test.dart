import 'package:example/details_page.dart';
import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/loading/font_loader.dart';

import 'nonvanilla_testing.dart';

void main() {
  setUpAll(loadAppFonts);

  group('Devices', () {
    testWidgets('check devices - Main Page', (tester) async {
      final nvGolden = NvGolden.devices(deviceSizes: [
        Device.iphone5s,
        Device.iphone12pro,
      ])
        ..addScenario(
          name: 'Title',
          widget: MyApp(),
        );
      await tester.createGolden(nvGolden, 'devices/main_page');
    });

    testWidgets('check devices - Details Page', (tester) async {
      final nvGolden = NvGolden.devices(deviceSizes: [
        Device.iphone5s,
        Device.iphone12pro,
      ])
        ..addScenario(
          name: 'Title',
          widget: DetailsPage(
            entry: Entry(text: 'Test text', state: CheckState.inProgress),
          ),
        );
      await tester.createGolden(nvGolden, 'devices/details_page');
    });
  });

  group('Interaction', () {
    testWidgets('Details Page', (tester) async {
      final nvWrapper = NvWidgetWrapper()..withDirectionality();

      final nvGolden = NvGolden.(deviceSizes: [
        Device.iphone5s,
        Device.iphone12pro,
      ])
        ..addScenario(
          name: 'Title',
          widget: nvWrapper.wrap(
            DetailsPage(
              entry: Entry(text: 'Test text', state: CheckState.inProgress),
            ),
          ),
        );
      await tester.createGolden(nvGolden, 'interaction/details_page');
    });
  });
}
