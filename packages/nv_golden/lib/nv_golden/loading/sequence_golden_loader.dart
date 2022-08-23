import 'dart:io';

import 'package:path/path.dart' as path;

File goldenFilePath(String golden) {
  final uri = Uri.parse(golden);
  final path.Context context = path.Context(style: path.Style.platform);
  final String testFilePath = context.fromUri(uri);
  final String testDirectoryPath = context.dirname(testFilePath);
  final basedir = context.toUri(testDirectoryPath + context.separator);

  return File(
    path.join(
      Directory.current.path,
      'test',
      path.fromUri(basedir),
      uri.pathSegments.last,
    ),
  );
}
