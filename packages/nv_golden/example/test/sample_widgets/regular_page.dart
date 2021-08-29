import 'package:flutter/material.dart';

class RegularPage extends StatelessWidget {
  const RegularPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
