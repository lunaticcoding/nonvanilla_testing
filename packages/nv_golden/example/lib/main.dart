import 'package:example/components/delete_icon.dart';
import 'package:example/components/state_icon.dart';
import 'package:example/details_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Entry> entries = [
    Entry(text: "Hello World!", state: CheckState.done),
    Entry(text: "Some Task", state: CheckState.nothing),
    Entry(text: "Running Out of task names", state: CheckState.inProgress),
    Entry(text: "And one more", state: CheckState.done),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Title'),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final entry = entries[i];

            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailsPage(entry: entry)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StateIcon(state: entry.state),
                    const SizedBox(width: 10),
                    Text(
                      entry.text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    DeleteIcon(
                      onTap: () => setState(
                        () => entries =
                            entries.where((e) => e.text != entry.text).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, _) => SizedBox(height: 10),
        ),
      ),
    );
  }
}

enum CheckState {
  done,
  inProgress,
  nothing,
}

extension CheckStateExtension on CheckState {
  T map<T>({
    required T done,
    required T inProgress,
    required T nothing,
  }) {
    switch (this) {
      case CheckState.done:
        return done;
      case CheckState.inProgress:
        return inProgress;
      case CheckState.nothing:
        return nothing;
    }
  }
}

class Entry {
  final CheckState state;
  final String text;

  const Entry({
    required this.text,
    required this.state,
  });
}
