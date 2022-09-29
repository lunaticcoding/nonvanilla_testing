import 'package:example/details_page.dart';
import 'package:example/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/models/nv_gesture.dart';

Future<void> main() async {
  setUpAll(NvGolden.init);

  testWidgets('Details Page', (tester) async {
    final nvGolden = NvGolden.singular(
      screen: Device.iphone5s,
      widget: DetailsPage(
        entry: Entry(text: 'Test text', state: CheckState.inProgress),
      ),
    );

    await tester.pumpSequence(nvGolden);

    await tester.createSequenceGolden(
      nvGolden,
      'details_page_drag/0',
    );

    await tester.createSequenceGolden(
      nvGolden,
      'details_page_drag/1',
      gestures: [
        NvGestureDrag(
          finder: () => find.byType(Image).at(1),
          offset: Offset(-100, 0),
        ),
      ],
    );

    await tester.createSequenceGolden(
      nvGolden,
      'details_page_drag/2',
    );
  });
}
