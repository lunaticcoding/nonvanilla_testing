import 'dart:collection';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nv_golden/nv_golden/screen.dart';

import 'scenario.dart';

class NvGolden {
  static const double _padding = 8;
  final int nrColumns;
  final List<Scenario> _scenarios;
  final List<Screen> _deviceSizes;
  final Widget Function(Widget child)? wrap;

  NvGolden.grid({required this.nrColumns, Screen? screen, this.wrap})
      : _scenarios = [],
        _deviceSizes = screen != null ? [screen] : [];

  NvGolden.devices({required List<Screen> deviceSizes, this.wrap})
      : nrColumns = deviceSizes.length,
        _scenarios = [],
        _deviceSizes = deviceSizes,
        assert(deviceSizes.isNotEmpty);

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
    final totalSize = nvGolden.size;

    await binding.setSurfaceSize(Size(totalSize.width, totalSize.height));

    await pumpWidget(widget);
    await expectLater(
      find.byWidget(widget),
      matchesGoldenFile('goldens/$goldenName.png'),
    );
  }
}

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
