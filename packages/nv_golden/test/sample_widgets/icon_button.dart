import 'package:flutter/material.dart';

class SampleIconButton extends StatefulWidget {
  final String text;
  final IconData icon;

  const SampleIconButton({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  State<SampleIconButton> createState() => _SampleIconButtonState();
}

class _SampleIconButtonState extends State<SampleIconButton> {
  Color color = purple;
  static const purple = Colors.deepPurpleAccent;
  static const green = Colors.green;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        color = color == purple ? green : purple;
      }),
      child: Container(
        color: color,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              widget.text,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
