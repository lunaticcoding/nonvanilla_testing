import 'package:flutter/widgets.dart';
import 'package:nv_golden/nv_golden/nv_golden_base.dart';
import 'package:nv_golden/nv_golden/screen.dart';

/// The NvGolden class for single golden test with assertions as well as
/// sequence testing
class NvGoldenSingular extends NvGoldenBase {
  final Key uniqueKey;
  @override
  final Widget widget;
  final Screen screen;

  /// The NvGolden class for single golden test with assertions as well as
  /// sequence testing
  NvGoldenSingular({
    required this.widget,
    required this.screen,
  })  : uniqueKey = UniqueKey(),
        super(wrap: (Widget child) => child);

  @override
  Size get size => screen.size;
}
