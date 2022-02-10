import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/create_golden.dart';
import 'package:nv_golden/nv_golden/widget_wrapper.dart';

import 'nonvanilla_testing.dart';
import 'sample_widgets/icon_button.dart';

void main() {
  setUpAll(() async {
    await NvGolden.loadFont(
      name: 'Roboto',
      paths: ['lib/fonts/Roboto-Regular.ttf'],
    );
  });

  testWidgets('test widget with custom font loader in 2x2 grid',
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

    await tester.createGolden(nvGolden, 'custom_font_icon_button');
  });
}
