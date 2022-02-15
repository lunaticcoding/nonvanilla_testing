import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nv_golden/nv_golden/nv_golden_base.dart';
import 'package:nv_golden/nv_golden/screen.dart';

import 'iterable_extensions.dart';
import 'scenario.dart';

/// The NvGolden class for golden tests with multiple instances of the tested
/// Scenario(s) in a single file.
class NvGoldenMultiple extends NvGoldenBase {
  static const double _padding = 8;
  final int nrColumns;
  final List<Scenario> _scenarios;
  final List<Screen> _deviceSizes;
  final Widget Function(Widget child)? wrapScenario;
  final BoxDecoration? decoration;

  /// Constructor for grid tests
  NvGoldenMultiple.grid({
    required this.nrColumns,
    Screen? screen,
    required Widget Function(Widget child)? wrap,
    this.wrapScenario,
    this.decoration,
  })  : _scenarios = [],
        _deviceSizes = screen != null ? [screen] : [],
        super(wrap: wrap);

  /// Constructor for device tests
  NvGoldenMultiple.devices({
    required List<Screen> deviceSizes,
    BoxDecoration? decoration,
    required Widget Function(Widget child)? wrap,
    this.wrapScenario,
  })  : nrColumns = deviceSizes.length,
        _scenarios = [],
        _deviceSizes = deviceSizes,
        decoration = decoration ?? BoxDecoration(border: Border.all()),
        assert(deviceSizes.isNotEmpty),
        super(wrap: wrap);

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
          wrap: wrapScenario,
        ),
      );
    else
      _scenarios.addAll(
        _deviceSizes.map(
          (screen) => Scenario(
            name: name,
            widget: widget,
            screen: screen,
            wrap: wrapScenario,
          ),
        ),
      );
  }

  /// Expose the widget for the golden builder files.
  Widget get widget => Container(
        color: Colors.white,
        padding: EdgeInsets.all(_padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
      ? scenarios.map((scenario) => scenario.build(decoration)).first
      : Row(
          mainAxisSize: MainAxisSize.min,
          children:
              scenarios.map((scenario) => scenario.build(decoration)).toList(),
        );
}
