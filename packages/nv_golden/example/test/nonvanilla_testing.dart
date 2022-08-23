import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:nv_golden/nv_golden.dart';

class NvWrapper extends NvWidgetWrapper {
  void withDirectionality({TextDirection? textDirection}) => add(
        (child) => Directionality(
          textDirection: textDirection ?? TextDirection.ltr,
          child: child,
        ),
      );

  void withMaterialApp() => add(
        (child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: child,
        ),
      );
}
