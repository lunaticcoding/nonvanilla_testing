import 'dart:math';

import 'package:image/image.dart';

void fillCustomRect(
  Image image,
  int x0,
  int y0,
  int x1,
  int y1,
  int x2,
  int y2,
  int x3,
  int y3,
  int color,
) {
  final minY = min(min(y0, y1), min(y2, y3));
  final maxY = max(max(y0, y1), max(y2, y3));
  final minX = min(min(x0, x1), min(x2, x3));
  final maxX = max(max(x0, x1), max(x2, x3));

  for (int x = minX; x <= maxX; x++) {
    for (int y = minY; y <= maxY; y++) {
      if (_isPointInRectangle(x0, y0, x1, y1, x2, y2, x, y)) {
        drawPixel(image, x, y, color);
      }
    }
  }
}

/// Checks if a point P is inside a rect given by A, B and C.
bool _isPointInRectangle(xA, yA, xB, yB, xC, yC, xP, yP) {
  final ab = Vector(xA, yA, xB, yB);
  final ap = Vector(xA, yA, xP, yP);
  final bc = Vector(xB, yB, xC, yC);
  final bp = Vector(xB, yB, xP, yP);

  final dotABAM = _dot(ab, ap);
  final dotABAB = _dot(ab, ab);
  final dotBCBM = _dot(bc, bp);
  final dotBCBC = _dot(bc, bc);

  return 0 <= dotABAM &&
      dotABAM <= dotABAB &&
      0 <= dotBCBM &&
      dotBCBM <= dotBCBC;
}

int _dot(Vector u, Vector v) => u.x * v.x + u.y * v.y;

class Vector {
  final int x;
  final int y;

  Vector(int x0, int y0, int x1, int y1)
      : x = x1 - x0,
        y = y1 - y0;
}

class Point {
  final int x;
  final int y;

  Point({required this.x, required this.y});
}
