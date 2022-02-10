import 'package:flutter/services.dart';

abstract class NvFontLoader {
  static Future<void> loadFonts(Map<String, List<String>> fontMap) async {
    final fonts = fontMap.entries
        .map((entry) =>
            _getFontLoader(family: entry.key, filePaths: entry.value))
        .toList();
    Future.wait(fonts.map((loader) => loader.load()));
  }

  static FontLoader _getFontLoader({
    required String family,
    required List<String> filePaths,
  }) {
    final fontLoader = FontLoader(family);
    filePaths.forEach((filePath) {
      fontLoader.addFont(rootBundle.load(filePath));
    });

    return fontLoader;
  }
}
