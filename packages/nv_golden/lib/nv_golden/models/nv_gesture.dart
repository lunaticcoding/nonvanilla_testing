import 'package:flutter_test/flutter_test.dart';

abstract class NvGesture {
  final bool apply;
  final Finder Function() finder;

  NvGesture(this.apply, this.finder);

  static NvGestureTap tap({
    required Finder Function() finder,
    bool apply = true,
  }) =>
      NvGestureTap(finder: finder, apply: apply);
}

class NvGestureTap extends NvGesture {
  final Finder Function() finder;

  NvGestureTap({
    required this.finder,
    required bool apply,
  }) : super(apply, finder);
}
