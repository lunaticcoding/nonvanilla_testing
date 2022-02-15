import 'dart:collection';

import 'package:flutter/widgets.dart';

/// A widget wrapper which can be extended to make the widget wrapping much
/// cleaner.
class NvWidgetWrapper {
  final Queue<Widget Function(Widget child)> _widgetQueue;

  /// A widget wrapper which can be extended to make the widget wrapping much
  /// cleaner.
  NvWidgetWrapper() : _widgetQueue = Queue();

  /// Wrap the passed Widget with all Widget the WidgetWrapper has in
  /// it's Queue.
  Widget wrap(Widget child) =>
      _widgetQueue.fold(child, (child, function) => function(child));

  /// Add widget at lowest level of WidgetWrapper
  void add(Widget Function(Widget child) function) =>
      _widgetQueue.add(function);

  /// Create new instance with same widgets being applied on top.
  NvWidgetWrapper clone() =>
      NvWidgetWrapper().._widgetQueue.addAll(this._widgetQueue.toList());
}
