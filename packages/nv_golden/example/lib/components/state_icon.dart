import 'package:example/main_page.dart';
import 'package:flutter/material.dart' hide State;

class StateIcon extends StatelessWidget {
  final CheckState state;

  const StateIcon({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
        color: state.map(
          done: Colors.green,
          inProgress: Colors.amberAccent,
          nothing: Colors.grey,
        ),
      ),
      child: Icon(
        state.map(
          done: Icons.check_circle_outline,
          inProgress: Icons.handyman,
          nothing: Icons.access_alarm,
        ),
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
