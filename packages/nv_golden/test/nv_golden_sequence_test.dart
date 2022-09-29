import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/models/nv_gesture.dart';

import 'nonvanilla_testing.dart';
import 'sample_widgets/icon_button.dart';

Future<void> main() async {
  setUpAll(NvGolden.init);

  testWidgets('toggle IconButton color on icon clicked', (tester) async {
    final nvWrapper = NvWidgetWrapper()..withDirectionality();
    final largeScreen = Screen(size: Size(200, 100));

    final nvGolden = NvGolden.singular(
      widget: nvWrapper.wrap(
        SampleIconButton(text: 'icon 1', icon: Icons.title),
      ),
      screen: largeScreen,
    );

    await tester.pumpSequence(nvGolden);
    final finder = () => find.byType(Icon);

    await tester.createSequenceGolden(
      nvGolden,
      'sequence-icon-button-1',
      gestures: [NvGestureTap(finder: finder)],
    );
    await tester.createSequenceGolden(
      nvGolden,
      'sequence-icon-button-2',
      gestures: [NvGestureTap(finder: finder)],
    );
    await tester.createSequenceGolden(
      nvGolden,
      'sequence-icon-button-3',
      gestures: [NvGestureTap(finder: finder)],
    );
  });
}
