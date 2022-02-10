import 'package:flutter/widgets.dart';

abstract class NvGoldenBase {
  final Widget Function(Widget child)? wrap;

  Widget get widget;
  Size get size;

  NvGoldenBase({required this.wrap});
}
