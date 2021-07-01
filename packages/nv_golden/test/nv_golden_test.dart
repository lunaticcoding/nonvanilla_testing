import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/loading/font_loader.dart';
import 'package:nv_golden/nv_golden/screen.dart';
import 'nonvanilla_testing.dart';
import 'sample_widgets/icon_button.dart';
import 'sample_widgets/image_button.dart';
import 'sample_widgets/mediaquery_page.dart';
import 'sample_widgets/regular_page.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('test widget with universal screen size in 2x2 grid',
      (tester) async {
    final nvWrapper = NvWidgetWrapper()..withDirectionality();
    final smallDevice = Screen(size: Size(150, 60));

    final nvGolden = NvGolden.grid(nrColumns: 2, screen: smallDevice)
      ..addScenario(
        name: 'Icon 1',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 1', icon: Icons.title),
        ),
      )
      ..addScenario(
        name: 'Icon 2',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 2', icon: Icons.build),
        ),
      )
      ..addScenario(
        name: 'Icon 3',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 3', icon: Icons.expand),
        ),
      )
      ..addScenario(
        name: 'Icon 4',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 4', icon: Icons.circle),
        ),
      );

    await tester.createGolden(nvGolden, 'icon_button_universal_size');
  });

  testWidgets('test widget with different screen sizes in 2x2 grid',
      (tester) async {
    final nvWrapper = NvWidgetWrapper()..withDirectionality();
    final smallScreen = Screen(size: Size(150, 60));
    final largeScreen = Screen(size: Size(200, 100));

    final nvGolden = NvGolden.grid(nrColumns: 2)
      ..addScenario(
        name: 'Icon 1',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 1', icon: Icons.title),
        ),
        screen: smallScreen,
      )
      ..addScenario(
        name: 'Icon 2',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 2', icon: Icons.build),
        ),
        screen: largeScreen,
      )
      ..addScenario(
        name: 'Icon 3',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 3', icon: Icons.expand),
        ),
        screen: largeScreen,
      )
      ..addScenario(
        name: 'Icon 4',
        widget: nvWrapper.wrap(
          SampleIconButton(text: 'icon 4', icon: Icons.circle),
        ),
        screen: smallScreen,
      );

    await tester.createGolden(nvGolden, 'icon_button_custom_sizes');
  });

  testWidgets('test full page with and without media query on 2 devices',
      (tester) async {
    final nvWrapper = NvWidgetWrapper()..withDirectionality();

    final nvGolden =
        NvGolden.devices(deviceSizes: [Device.iphone12pro, Device.iphone5s])
          ..addScenario(
            name: 'Page using MediaQuery',
            widget: nvWrapper.wrap(MediaQueryPage()),
          )
          ..addScenario(
            name: 'Page without using MediaQuery',
            widget: nvWrapper.wrap(RegularPage()),
          );

    await tester.createGolden(nvGolden, 'multiple_device_media_query_page');
    await tester.createGolden(nvGolden, 'image_button');
  });

  testWidgets('test image loading', (tester) async {
    final nvWrapper = NvWidgetWrapper()..withDirectionality();

    final nvGolden =
        NvGolden.grid(nrColumns: 1, screen: Screen(size: Size(300, 350)))
          ..addScenario(
            name: 'Page using MediaQuery',
            widget: nvWrapper.wrap(SampleImageButton()),
          );

    await tester.createGolden(nvGolden, 'image_button');
  });
}
