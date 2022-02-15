import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden.dart';
import 'package:nv_golden/nv_golden/create_golden.dart';
import 'package:nv_golden/nv_golden/screen.dart';
import 'package:nv_golden/nv_golden/widget_wrapper.dart';

import 'nonvanilla_testing.dart';
import 'sample_widgets/image_button.dart';

void main() {
  setUpAll(NvGolden.init);

  testWidgets('renders a singular golden', (tester) async {
    final nvWrapper = NvWidgetWrapper()..withDirectionality();

    final nvGolden = NvGolden.singular(
      widget: nvWrapper.wrap(SampleImageButton()),
      screen: Screen(size: Size(300, 350)),
    );

    await tester.createGolden(nvGolden, 'singular_golden');
  });
}
