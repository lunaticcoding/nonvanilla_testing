import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_golden/nv_golden/loading/font_loader.dart';
import 'package:nv_golden/nv_golden/loading/nv_font_loader.dart';
import 'package:nv_golden/nv_golden/loading/test_asset_bundle.dart';

import 'iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nv_golden/nv_golden/screen.dart';

import 'scenario.dart';

/// The central class of our golden testing framework. It provides a small but
/// powerful interface for golden tests.
class NvGolden {
  static const double _padding = 8;
  final int nrColumns;
  final List<Scenario> _scenarios;
  final List<Screen> _deviceSizes;
  final Widget Function(Widget child)? wrap;

  /// Constructor for widget tests
  NvGolden.grid({required this.nrColumns, Screen? screen, this.wrap})
      : _scenarios = [],
        _deviceSizes = screen != null ? [screen] : [];

  /// Constructor for device tests
  NvGolden.devices({required List<Screen> deviceSizes, this.wrap})
      : nrColumns = deviceSizes.length,
        _scenarios = [],
        _deviceSizes = deviceSizes,
        assert(deviceSizes.isNotEmpty);

  /// Initialize golden tests
  static Future<void> init() async => loadAppFonts();

  /// Add a golden test scenario
  void addScenario({
    required String name,
    required Widget widget,
    Screen? screen,
  }) {
    assert(_deviceSizes.isEmpty != (screen == null));

    if (screen != null)
      return _scenarios.add(
        Scenario(
          name: name,
          widget: widget,
          screen: screen,
        ),
      );
    else
      _scenarios.addAll(
        _deviceSizes.map(
          (screen) => Scenario(
            name: name,
            widget: widget,
            screen: screen,
          ),
        ),
      );
  }

  Widget get widget => Container(
        color: Colors.white,
        padding: EdgeInsets.all(_padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: _scenarios
              .mapGrouped(
                _mapScenariosToRow,
                n: nrColumns,
              )
              .toList(),
        ),
      );

  /// Calculate the size for the whole golden file
  Size get size {
    final widths = _scenarios.mapGrouped(
      (scenarios) => scenarios.fold<double>(
          0.0, (acc, scenario) => acc + scenario.size.width),
      n: nrColumns,
    );
    final totalWidth =
        widths.fold(0.0, (double acc, value) => max(acc, value)) + _padding * 2;

    final heights = _scenarios.mapGrouped(
      (scenarios) => scenarios.fold<double>(
          0.0, (acc, scenario) => max(acc, scenario.size.height)),
      n: nrColumns,
    );
    final totalHeight =
        heights.fold<double>(0.0, (acc, value) => acc + value) + _padding * 2;

    return Size(totalWidth, totalHeight);
  }

  Widget _mapScenariosToRow(List<Scenario> scenarios) => scenarios.length == 1
      ? scenarios.map((scenario) => scenario.build()).first
      : Row(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: scenarios
              .map(
                (scenario) => wrap?.call(scenario.build()) ?? scenario.build(),
              )
              .toList(),
        );
}

extension CreateGolden on WidgetTester {
  Future<void> createGolden(NvGolden nvGolden, String goldenName) async {
    final widget = nvGolden.widget;
    final screenSize = nvGolden.size;

    await binding.setSurfaceSize(screenSize);
    binding.window.physicalSizeTestValue = screenSize;
    binding.window.devicePixelRatioTestValue = 1.0;
    binding.window.textScaleFactorTestValue = 1.0;

    await _defaultPrimeAssets();

    await pumpWidget(
      DefaultAssetBundle(bundle: TestAssetBundle(), child: widget),
    );
    await pump();

    await expectLater(
      find.byWidget(widget),
      matchesGoldenFile('goldens/$goldenName.png'),
    );
  }

  /// A function that waits for all [Image] widgets found in the widget tree to finish decoding.
  ///
  /// Currently this supports images included via Image widgets, or as part of BoxDecorations.
  Future<void> _defaultPrimeAssets() async {
    final imageElements = find.byType(Image, skipOffstage: false).evaluate();
    final containerElements =
        find.byType(DecoratedBox, skipOffstage: false).evaluate();
    await runAsync(() async {
      for (final imageElement in imageElements) {
        final widget = imageElement.widget;
        if (widget is Image) {
          await precacheImage(widget.image, imageElement);
        }
      }
      for (final container in containerElements) {
        final widget = container.widget as DecoratedBox;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          if (decoration.image != null) {
            await precacheImage(decoration.image!.image, container);
          }
        }
      }
    });
  }
}

/// A widget wrapper which can be extended to make the widget wrapping much
/// cleaner.
class NvWidgetWrapper {
  final Queue<Widget Function(Widget child)> _widgetQueue;

  NvWidgetWrapper() : _widgetQueue = Queue();

  Widget wrap(Widget child) =>
      _widgetQueue.fold(child, (child, function) => function(child));

  void add(Widget Function(Widget child) function) =>
      _widgetQueue.add(function);

  NvWidgetWrapper clone() =>
      NvWidgetWrapper().._widgetQueue.addAll(this._widgetQueue.toList());
}
