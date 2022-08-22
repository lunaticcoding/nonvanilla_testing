import 'package:flutter/material.dart' hide State;

class DeleteIcon extends StatelessWidget {
  final VoidCallback onTap;
  const DeleteIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          color: Colors.red,
        ),
        child: Icon(
          Icons.close,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
