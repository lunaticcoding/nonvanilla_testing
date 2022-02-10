import 'package:flutter/widgets.dart';
import 'package:nv_golden/nv_golden/nv_golden_base.dart';
import 'package:nv_golden/nv_golden/screen.dart';

class NvGoldenSingular extends NvGoldenBase {
  @override
  final Widget widget;
  final Screen screen;

  NvGoldenSingular({
    required this.widget,
    required this.screen,
  }) : super(wrap: (Widget child) => child);

  @override
  Size get size => screen.size;
}
