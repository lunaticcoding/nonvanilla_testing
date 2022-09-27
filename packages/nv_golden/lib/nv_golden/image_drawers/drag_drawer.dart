import 'dart:math';

import 'package:image/image.dart';
import 'package:nv_golden/nv_golden/image_drawers/custom_rect_drawer.dart';

void drawDrag(
  Image image,
  int x0,
  int y0,
  int x1,
  int y1,
  int size,
) {
  final white = getColor(255, 255, 255);
  final grey = getColor(200, 200, 200);

  final xV = x0 - x1;
  final yV = y0 - y1;

  final xd =
      sqrt((pow(20, 2) * pow(yV, 2)) / (pow(xV, 2) + pow(yV, 2))).round();
  final yd = yV == 0 ? size : (xV * xd / (-yV)).round();

  fillCustomRect(
    image,
    x0 + xd,
    y0 + yd,
    x1 + xd,
    y1 + yd,
    x1 - xd,
    y1 - yd,
    x0 - xd,
    y0 - yd,
    grey,
  );

  fillCircle(image, x1, y1, size, grey);
  fillCircle(image, x0, y0, size, white);
}
