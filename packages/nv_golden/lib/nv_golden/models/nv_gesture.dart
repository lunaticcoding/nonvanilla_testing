import 'package:flutter_test/flutter_test.dart';

abstract class NvGesture {
  final bool apply;
  final Finder Function() finder;

  NvGesture({required this.apply, required this.finder});

  T map<T>({
    required T Function(NvGestureTap) tap,
    required T Function(NvGestureDrag) drag,
    bool apply = true,
  }) {
    if (this is NvGestureTap) {
      return tap(this as NvGestureTap);
    } else if (this is NvGestureDrag) {
      return drag(this as NvGestureDrag);
    }
    throw Exception('Gesture not registered with NvGesture.map function');
  }
}

class NvGestureTap extends NvGesture {
  NvGestureTap({
    required super.finder,
    super.apply = true,
  });
}

class NvGestureDrag extends NvGesture {
  final Offset offset;

  NvGestureDrag({
    required super.finder,
    required this.offset,
    super.apply = true,
  });
}
