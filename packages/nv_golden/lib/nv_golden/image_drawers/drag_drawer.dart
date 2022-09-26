import 'dart:math';

import 'package:image/image.dart';

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

  final alpha = asin((y0 - y1).abs() / (x0 - x1).abs());
  final yd = (size * cos(alpha)).round();
  final xd = (size * sin(alpha)).round();

  fillRect(image, x0 + xd, y0 + yd, x1 - xd, y1 - yd, grey);
  fillCircle(image, x1, y1, size, grey);
  fillCircle(image, x0, y0, size, white);
}
