import 'package:flutter/material.dart';
import 'package:hive_demo/hive_to_do_class.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("HiveTextBox");
  runApp(const HiveToDoDemo());
}
