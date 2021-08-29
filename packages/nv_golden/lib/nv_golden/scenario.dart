import 'package:flutter/material.dart';
import 'package:nv_golden/nv_golden/screen.dart';

class Scenario {
  static const double _margin = 8;
  static const double _borderThickness = 1;
  static const double _textHeight = 30;
  static const double _space = 10;

  final Widget widget;
  final String name;
  final Screen screen;
  final Widget Function(Widget child)? wrap;

  Size get size => Size(
        screen.size.width + _margin * 2 + _borderThickness * 2,
        screen.size.height +
            _margin * 2 +
            _textHeight +
            _borderThickness * 2 +
            _space,
      );

  Scenario({
    required this.name,
    required this.widget,
    required this.screen,
    this.wrap,
  });

  Widget build(BoxDecoration? decoration) => Container(
        margin: const EdgeInsets.all(_margin),
        width: screen.size.width,
        height:
            screen.size.height + _textHeight + _borderThickness * 2 + _space,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: [
            Container(
              height: _textHeight,
              child: Center(
                child: Text(
                  screen.name != null ? '(${screen.name}) $name' : '$name',
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: _space),
            Container(
              width: screen.size.width,
              height: screen.size.height,
              clipBehavior: Clip.hardEdge,
              decoration: decoration ?? BoxDecoration(),
              child: Builder(
                builder: (context) {
                  final mediaQuery =
                      MediaQuery.maybeOf(context) ?? const MediaQueryData();
                  final mergedMediaQuery = mediaQuery.copyWith(
                    size: screen.size,
                    padding: screen.safeArea,
                    platformBrightness: screen.platformBrightness,
                    devicePixelRatio: screen.devicePixelRatio,
                    textScaleFactor: screen.textScaleFactor,
                  );

                  return MediaQuery(
                    data: mergedMediaQuery,
                    child: wrap?.call(widget) ?? widget,
                  );
                },
              ),
            ),
          ],
        ),
      );
}
