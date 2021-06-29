import 'package:flutter/material.dart';

/// The Screen class can be used to create your own devices as well as simply
/// the sizes for the widgets you want to test.
class Screen {
  final String? name;
  final Size size;
  final double devicePixelRatio;
  final double textScaleFactor;
  final Brightness platformBrightness;
  final EdgeInsets safeArea;
  final bool disableAnimations;

  const Screen({
    required this.size,
    this.devicePixelRatio = 1.0,
    this.textScaleFactor = 1.0,
    this.platformBrightness = Brightness.light,
    this.safeArea = EdgeInsets.zero,
    this.disableAnimations = true,
    this.name,
  });
}

/// Some common devices pre-created. We highly recommend including the iphone 5s
/// since it's one of the smallest screens still in circulation.
abstract class Device {
  static Screen get iphone5s => Screen(
        name: 'Iphone 5S',
        size: Size(320, 568),
      );
  static Screen get iphone12pro => Screen(
        name: 'Iphone 12 Pro',
        size: Size(390, 844),
      );
}
