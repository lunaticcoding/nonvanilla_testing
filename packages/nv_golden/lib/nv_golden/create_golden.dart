import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:nv_golden/nv_golden/image_drawers/drag_drawer.dart';
import 'package:nv_golden/nv_golden/loading/test_asset_bundle.dart';
import 'package:nv_golden/nv_golden/models/nv_gesture.dart';
import 'package:nv_golden/nv_golden/nv_golden_base.dart';
import 'package:nv_golden/nv_golden/nv_golden_singular.dart';
import 'package:nv_golden/nv_golden_icons.dart';

import 'loading/sequence_golden_loader.dart';

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
    binding.platformDispatcher.textScaleFactorTestValue = 1.0;

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

  /// Pumps the initial Widget for a Sequence. Needs to be called
  /// before the first [createSequenceGolden] call in your test.
  Future<void> pumpSequence(NvGoldenSingular nvGolden) async {
    final widget = MaterialApp(
      key: nvGolden.uniqueKey,
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: nvGolden.wrap?.call(nvGolden.widget) ?? nvGolden.widget,
      ),
      debugShowCheckedModeBanner: false,
    );
    final screenSize = nvGolden.size;

    await binding.setSurfaceSize(screenSize);
    binding.window.physicalSizeTestValue = screenSize;
    binding.window.devicePixelRatioTestValue = 1.0;
    binding.platformDispatcher.textScaleFactorTestValue = 1.0;

    await pumpWidget(widget);
    await _defaultPrimeAssets();
  }

  Future<void> createSequenceGolden(
    NvGoldenSingular nvGolden,
    String name, {
    List<NvGesture>? gestures,
    Future<void> Function()? afterPump,
    Color touchColor = Colors.orange,
  }) async {
    final isPumped = this.any(find.byKey(nvGolden.uniqueKey));

    if (!isPumped) {
      throw Exception('Make sure you called [pumpSequence] first!');
    }

    await pumpAndSettle();

    await expectLater(
      find.byKey(nvGolden.uniqueKey),
      matchesGoldenFile('goldens/$name.png'),
    );

    if (gestures?.isNotEmpty ?? false) {
      await _applyGesturesToGolden(
        nvGolden: nvGolden,
        name: name,
        gestures: gestures!,
      );
    }

    for (NvGesture gesture in gestures ?? []) {
      final finder = find.descendant(
        of: find.byKey(nvGolden.uniqueKey),
        matching: gesture.finder(),
      );
      await gesture.map(
        tap: (gesture) => tap(finder),
        drag: (gesture) => drag(finder, gesture.offset),
      );
    }

    await pumpAndSettle();
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

  Future<void> _applyGesturesToGolden({
    required NvGoldenSingular nvGolden,
    required String name,
    required List<NvGesture> gestures,
  }) async {
    final path = getGoldenFilePath('goldens/$name.png');
    final image = img.decodePng(File(path).readAsBytesSync())!;
    img.brightness(image, -150);

    for (NvGesture gesture in gestures) {
      gesture.map(
        tap: (gesture) {
          final center = getCenter(gesture.finder());
          img.fillCircle(
            image,
            center.dx.round(),
            center.dy.round(),
            20,
            img.getColor(255, 255, 255),
          );
        },
        drag: (gesture) {
          final center = getCenter(gesture.finder());
          drawDrag(
            image,
            center.dx.round() + gesture.offset.dx.round(),
            center.dy.round() + gesture.offset.dy.round(),
            center.dx.round(),
            center.dy.round(),
            20,
          );
        },
      );
    }

    File(path).writeAsBytesSync(img.encodePng(image));
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
        color: color.computeLuminance() < 0.3 ? Colors.white : Colors.black,
      ),
    );
  }
}
