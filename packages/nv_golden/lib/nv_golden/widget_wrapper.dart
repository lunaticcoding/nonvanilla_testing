import 'dart:collection';

import 'package:flutter/widgets.dart';

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
