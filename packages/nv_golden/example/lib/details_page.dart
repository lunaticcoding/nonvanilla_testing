import 'package:example/main.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Entry entry;

  const DetailsPage({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entry.text)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('images/pexels-lukas.jpg'),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lorem ipsum et dolor',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Zwei flinke Boxer jagen die quirlige Eva und ihren Mops durch Sylt. Franz jagt im komplett verwahrlosten Taxi quer durch Bayern. Zwölf Boxkämpfer jagen Viktor quer über den großen Sylter Deich. Vogel Quax zwickt Johnys Pferd Bim.',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(5),
              itemCount: 5,
              itemBuilder: (_, __) => Image.asset(
                'images/pexels-lukas.jpg',
                width: 355,
                height: 200,
                fit: BoxFit.cover,
              ),
              separatorBuilder: (_, __) => SizedBox(width: 10),
            ),
          ),
        ],
      ),
    );
  }
}
