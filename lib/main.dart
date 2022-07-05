import 'package:flutter/material.dart';
import 'package:hive_demo/hive_to_do_class.dart';
import 'package:hive_demo/to_do_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>("HiveBoxAddNotes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HiveToDoDemo(),
    );
  }
}
