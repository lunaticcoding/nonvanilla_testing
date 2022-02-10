import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/create_golden.dart';
import 'package:nv_golden/nv_golden/models/nv_gesture.dart';
import 'package:nv_golden/nv_golden/widget_wrapper.dart';

import 'nonvanilla_testing.dart';
import 'sample_widgets/icon_button.dart';

Future<void> main() async {
  setUpAll(NvGolden.init);

  testWidgets('test widget with different screen sizes in 2x2 grid',
      (tester) async {
    final nvWrapper = NvWidgetWrapper()..withDirectionality();
    final largeScreen = Screen(size: Size(200, 100));

    final nvGolden = NvGolden.singular(
      widget: nvWrapper.wrap(
        SampleIconButton(text: 'icon 1', icon: Icons.title),
      ),
      screen: largeScreen,
    );

    final finder = () => find.byType(Icon);

    await tester.createSequenceGolden(
      nvGolden,
      'name-1',
      gestures: [NvGesture.tap(finder: finder)],
    );
    await tester.createSequenceGolden(
      nvGolden,
      'name-2',
      gestures: [NvGesture.tap(finder: finder)],
    );
    await tester.createSequenceGolden(
      nvGolden,
      'name-3',
      gestures: [NvGesture.tap(finder: finder)],
    );
    await tester.createSequenceGolden(
      nvGolden,
      'name-4',
      gestures: [NvGesture.tap(finder: finder)],
    );
  });
}
