import 'package:example/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: MainPage(),
    );
  }
}

final lightTheme = ThemeData(
  primarySwatch: Colors.blueGrey,
);
