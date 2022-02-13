import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden/loading/test_asset_bundle.dart';
import 'package:nv_golden/nv_golden/models/nv_gesture.dart';
import 'package:nv_golden/nv_golden/nv_golden_base.dart';
import 'package:nv_golden/nv_golden/nv_golden_singular.dart';
import 'package:nv_golden/nv_golden_icons.dart';

extension CreateGolden on WidgetTester {
  Future<void> createGolden(
    NvGoldenBase nvGolden,
    String goldenName, {
    Future<void> Function()? afterPump,
  }) async {
    final widget = nvGolden.wrap?.call(nvGolden.widget) ??
        MaterialApp(
          home: nvGolden.widget,
          debugShowCheckedModeBanner: false,
        );
    final screenSize = nvGolden.size;

    await binding.setSurfaceSize(screenSize);
    binding.window.physicalSizeTestValue = screenSize;
    binding.window.devicePixelRatioTestValue = 1.0;
    binding.window.textScaleFactorTestValue = 1.0;

    await pumpWidget(
      DefaultAssetBundle(bundle: TestAssetBundle(), child: widget),
    );

    await _defaultPrimeAssets();

    await pumpAndSettle();
    await afterPump?.call();

    await expectLater(
      find.byWidget(widget),
      matchesGoldenFile('goldens/$goldenName.png'),
    );
  }

  Future<void> createSequenceGolden(
    NvGoldenSingular nvGolden,
    String name, {
    required List<NvGesture> gestures,
    Future<void> Function()? afterPump,
    Color touchColor = Colors.orange,
  }) async {
    final isPumped = this.any(find.byType(DefaultAssetBundle));

    if (!isPumped) {
      final widget = MaterialApp(
        home: nvGolden.wrap?.call(nvGolden.widget) ?? nvGolden.widget,
        debugShowCheckedModeBanner: false,
      );
      final screenSize = nvGolden.size;

      await binding.setSurfaceSize(screenSize);
      binding.window.physicalSizeTestValue = screenSize;
      binding.window.devicePixelRatioTestValue = 1.0;
      binding.window.textScaleFactorTestValue = 1.0;

      await _pumpWidgetWithGestures(widget, gestures: [], color: touchColor);
    }

    final widgetState = this.widget(find.byType(MaterialApp));
    await _pumpWidgetWithGestures(
      widgetState,
      gestures: gestures,
      color: touchColor,
    );

    await _defaultPrimeAssets();

    await pumpAndSettle();

    await expectLater(
      find.byType(DefaultAssetBundle),
      matchesGoldenFile('goldens/$name.png'),
    );

    await _pumpWidgetWithGestures(widgetState, gestures: [], color: touchColor);
    await afterPump?.call();

    for (NvGesture gesture in gestures) {
      final finder = find.descendant(
        of: find.byType(MaterialApp),
        matching: gesture.finder(),
      );
      await tap(finder);
    }
  }

  Future<void> _pumpWidgetWithGestures(
    Widget widget, {
    required List<NvGesture> gestures,
    required Color color,
  }) async {
    final widgetToPump = DefaultAssetBundle(
      bundle: TestAssetBundle(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            widget,
            ...gestures.map((gesture) {
              final center = getCenter(
                find.descendant(
                  of: find.byType(MaterialApp),
                  matching: gesture.finder().last,
                ),
              );
              return Positioned(
                left: center.dx - 19,
                top: center.dy - 19,
                child: TouchBadge(color: color),
              );
            }),
          ],
        ),
      ),
    );
    await pumpWidget(widgetToPump);
  }

  /// A function that waits for all [Image] widgets found in the widget tree to finish decoding.
  ///
  /// Currently this supports images included via Image widgets, or as part of BoxDecorations.
  Future<void> _defaultPrimeAssets() async {
    final imageElements = find.byType(Image, skipOffstage: false).evaluate();
    final containerElements =
        find.byType(DecoratedBox, skipOffstage: false).evaluate();
    await runAsync(() async {
      await Future.wait(imageElements.map((imageElement) {
        final widget = imageElement.widget;
        if (widget is Image) {
          return precacheImage(widget.image, imageElement);
        }
        return Future<void>(() {});
      }));

      await Future.wait(containerElements.map((container) {
        final widget = container.widget as DecoratedBox;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          if (decoration.image != null) {
            return precacheImage(decoration.image!.image, container);
          }
        }
        return Future<void>(() {});
      }));
    });
  }
}

class TouchBadge extends StatelessWidget {
  final Color color;

  const TouchBadge({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(
        NvGoldenIcon.tap,
        size: 30,
        color: color.computeLuminance() > 0.3 ? Colors.white : Colors.black,
      ),
    );
  }
}
