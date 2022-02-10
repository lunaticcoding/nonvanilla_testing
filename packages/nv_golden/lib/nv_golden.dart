library nv_golden;

import 'package:flutter/widgets.dart';
import 'package:nv_golden/nv_golden/loading/font_loader.dart';
import 'package:nv_golden/nv_golden/nv_golden_multiple.dart';
import 'package:nv_golden/nv_golden/nv_golden_singular.dart';
import 'package:nv_golden/nv_golden/screen.dart';

export 'nv_golden/create_golden.dart';
export 'nv_golden/nv_golden_multiple.dart';
export 'nv_golden/screen.dart' show Device, Screen;
export 'nv_golden/widget_wrapper.dart';

abstract class NvGolden {
  static NvGoldenMultiple grid({
    required int nrColumns,
    Screen? screen,
    Widget Function(Widget child)? wrap,
    Widget Function(Widget child)? wrapScenario,
    BoxDecoration? decoration,
  }) =>
      NvGoldenMultiple.grid(
        nrColumns: nrColumns,
        screen: screen,
        wrap: wrap,
        wrapScenario: wrapScenario,
        decoration: decoration,
      );

  static NvGoldenMultiple devices({
    required List<Screen> deviceSizes,
    Widget Function(Widget child)? wrap,
    Widget Function(Widget child)? wrapScenario,
    BoxDecoration? decoration,
  }) =>
      NvGoldenMultiple.devices(
        wrap: wrap,
        wrapScenario: wrapScenario,
        decoration: decoration,
        deviceSizes: deviceSizes,
      );

  static NvGoldenSingular singular({
    required Widget widget,
    required Screen screen,
  }) =>
      NvGoldenSingular(
        widget: widget,
        screen: screen,
      );

  /// Initialize golden tests
  static Future<void> init() => loadAppFonts();

  /// Optionally load fonts
  static Future<void> loadFont({
    required String name,
    required List<String> paths,
    bool isRelativePath = true,
  }) =>
      loadCustomFont(
        name: name,
        paths: paths,
        isRelativePath: isRelativePath,
      );
}
